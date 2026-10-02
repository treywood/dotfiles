/**
 * Edit Diff Syntax Highlight
 *
 * Re-renders the built-in `edit` tool's diffs with language-aware syntax
 * highlighting, in the spirit of diffs.nvim: the code keeps its syntax
 * colors inside added/removed/context lines, while the diff signal is
 * carried by the colored gutter (+/- line numbers) and an inverse-video
 * highlight on the exact tokens that changed within a modified line.
 *
 * How it works:
 * - Re-registers the built-in edit tool (same name), keeping its execute,
 *   argument preparation, and streaming preview behavior untouched.
 * - renderCall delegates to the built-in renderer (live plain preview while
 *   streaming). Once the tool settles, the body is rebuilt with the
 *   highlighted version of the final diff.
 * - To highlight with correct tokenizer context, the diff is deinterleaved
 *   into an "old" buffer (context + removed lines) and a "new" buffer
 *   (context + added lines), each passed through highlightCode(), then the
 *   styled lines are zipped back onto the diff lines.
 * - For single-line modifications (-/+ pair), a common prefix/suffix trim
 *   finds the changed span and marks it with inverse video (SGR-aware, so
 *   existing syntax colors survive).
 * - Added/removed lines get a subtle background tint derived by blending the
 *   theme's diff colors toward the surrounding header background (truecolor
 *   themes only). The tint ends by restoring the surrounding background
 *   rather than resetting it, so the Box's full-width padding stays intact.
 */

import {
	createEditToolDefinition,
	getLanguageFromPath,
	highlightCode,
	type EditToolDetails,
	type ExtensionAPI,
	type Theme,
} from "@earendil-works/pi-coding-agent";
import { Box, Container, Spacer, Text, getCapabilities, hyperlink } from "@earendil-works/pi-tui";
import { homedir } from "node:os";
import { resolve } from "node:path";
import { pathToFileURL } from "node:url";

// ---------------------------------------------------------------------------
// Diff parsing
// ---------------------------------------------------------------------------

type DiffEntry = { prefix: string; lineNum: string; content: string };

/** Same line format as the built-in display diff: "+123 code", "-123 code", " 123 code", or "     ..." */
function parseDiffLine(line: string): DiffEntry | null {
	const match = line.match(/^([+-\s])(\s*\d*)\s(.*)$/);
	if (!match) return null;
	return { prefix: match[1], lineNum: match[2], content: match[3] };
}

/** Context-elision marker emitted by the built-in diff generator (" ..." with a blank line number). */
function isMarker(entry: DiffEntry): boolean {
	return entry.lineNum.trim() === "";
}

function replaceTabs(text: string): string {
	return text.replace(/\t/g, "   ");
}

// ---------------------------------------------------------------------------
// Diff line background tints
// ---------------------------------------------------------------------------

/** Fraction of the diff color blended into the surrounding background for added/removed line tints. */
const DIFF_LINE_BG_STRENGTH = 0.28;

function parseRgb(ansi: string, sgrCode: "38" | "48"): { r: number; g: number; b: number } | null {
	const m = ansi.match(new RegExp(`${sgrCode};2;(\\d+);(\\d+);(\\d+)`));
	if (!m) return null;
	return { r: Number(m[1]), g: Number(m[2]), b: Number(m[3]) };
}

/** Blend a foreground color toward the surrounding background; null when either isn't truecolor RGB. */
function blendToward(fgAnsi: string, surroundAnsi: string, strength: number): string | null {
	const fg = parseRgb(fgAnsi, "38");
	const bg = parseRgb(surroundAnsi, "48");
	if (!fg || !bg) return null;
	const r = Math.round(bg.r + (fg.r - bg.r) * strength);
	const g = Math.round(bg.g + (fg.g - bg.g) * strength);
	const b = Math.round(bg.b + (fg.b - bg.b) * strength);
	return `\x1b[48;2;${r};${g};${b}m`;
}

// ---------------------------------------------------------------------------
// SGR-aware inverse-video range styling
// ---------------------------------------------------------------------------

const ESC = "";
const ANSI_RE = /^\[([0-9;?]*)([A-Za-z])/;
const ANSI_STRIP_RE = /\[[0-9;?]*[A-Za-z]/g;

function stripAnsi(text: string): string {
	return text.replace(ANSI_STRIP_RE, "");
}

/** Track inverse state through an SGR sequence, skipping extended-color parameters. */
function applySgr(params: number[], state: { inverse: boolean }): void {
	let k = 0;
	while (k < params.length) {
		const p = params[k];
		if (p === 0) state.inverse = false;
		else if (p === 7) state.inverse = true;
		else if (p === 27) state.inverse = false;
		else if (p === 38 || p === 48 || p === 58) {
			// Extended color: 38;5;n or 38;2;r;g;b (also bg/underline variants)
			if (params[k + 1] === 5) k += 2;
			else if (params[k + 1] === 2) k += 4;
		}
		k++;
	}
}

/**
 * Wrap the visible-character range [start, end) of an ANSI-styled string in
 * inverse video, preserving any syntax colors already present. Re-asserts
 * inverse after mid-range SGR resets.
 */
function withInverseRange(line: string, start: number, end: number): string {
	if (start >= end) return line;
	let out = "";
	let col = 0;
	let i = 0;
	const state = { inverse: false };
	const enable = () => {
		if (!state.inverse) {
			out += `${ESC}[7m`;
			state.inverse = true;
		}
	};
	const disable = () => {
		if (state.inverse) {
			out += `${ESC}[27m`;
			state.inverse = false;
		}
	};
	while (i < line.length) {
		if (line[i] === ESC && line[i + 1] === "[") {
			const m = ANSI_RE.exec(line.slice(i));
			if (m) {
				out += m[0];
				if (m[2] === "m") {
					const params = m[1] === "" ? [0] : m[1].split(";").map((x) => parseInt(x || "0", 10));
					applySgr(params, state);
					if (col >= start && col < end) enable();
				}
				i += m[0].length;
				continue;
			}
		}
		if (col === start) enable();
		if (col === end) disable();
		out += line[i];
		col++;
		i++;
	}
	disable();
	return out;
}

// ---------------------------------------------------------------------------
// Word-level change spans (common prefix/suffix trim)
// ---------------------------------------------------------------------------

function changedSpan(a: string, b: string): { aStart: number; aEnd: number; bStart: number; bEnd: number } {
	const max = Math.min(a.length, b.length);
	let p = 0;
	while (p < max && a[p] === b[p]) p++;
	let s = 0;
	while (s < max - p && a[a.length - 1 - s] === b[b.length - 1 - s]) s++;
	return { aStart: p, aEnd: a.length - s, bStart: p, bEnd: b.length - s };
}

// ---------------------------------------------------------------------------
// Highlighted diff renderer
// ---------------------------------------------------------------------------

function renderHighlightedDiff(
	diffText: string,
	filePath: string | undefined,
	theme: Theme,
	surroundBg?: "toolSuccessBg" | "toolErrorBg" | "toolPendingBg",
): string {
	const rawLines = diffText.split("\n");
	const entries = rawLines.map(parseDiffLine);
	const lang = filePath ? getLanguageFromPath(filePath) : undefined;

	// Line tints for added/removed rows. The tint closes by restoring the
	// surrounding background (not [49m) so the outer Box's padding keeps its bg.
	let removedBg: string | null = null;
	let addedBg: string | null = null;
	let surroundAnsi = "";
	if (surroundBg) {
		try {
			surroundAnsi = theme.getBgAnsi(surroundBg);
			removedBg = blendToward(theme.getFgAnsi("toolDiffRemoved"), surroundAnsi, DIFF_LINE_BG_STRENGTH);
			addedBg = blendToward(theme.getFgAnsi("toolDiffAdded"), surroundAnsi, DIFF_LINE_BG_STRENGTH);
		} catch {
			// leave tints disabled
		}
	}
	const tint = (line: string, bg: string | null) => (bg && surroundAnsi ? bg + line + surroundAnsi : line);

	// Deinterleave into old-side (context + removed) and new-side (context + added)
	// buffers so the highlighter sees contiguous code.
	const oldBuf: string[] = [];
	const newBuf: string[] = [];
	for (const e of entries) {
		if (!e || isMarker(e)) continue;
		const c = replaceTabs(e.content);
		if (e.prefix !== "+") oldBuf.push(c);
		if (e.prefix !== "-") newBuf.push(c);
	}

	let oldHi: string[] = oldBuf;
	let newHi: string[] = newBuf;
	if (lang) {
		try {
			const oh = highlightCode(oldBuf.join("\n"), lang);
			const nh = highlightCode(newBuf.join("\n"), lang);
			// Only trust the styled output if it maps 1:1 onto the source lines.
			if (oh.length === oldBuf.length && oh.every((l, idx) => stripAnsi(l) === oldBuf[idx])) oldHi = oh;
			if (nh.length === newBuf.length && nh.every((l, idx) => stripAnsi(l) === newBuf[idx])) newHi = nh;
		} catch {
			// fall back to unstyled lines
		}
	}

	const colorFor = (prefix: string) =>
		prefix === "+" ? "toolDiffAdded" : prefix === "-" ? "toolDiffRemoved" : "toolDiffContext";
	const gutter = (e: DiffEntry) => theme.fg(colorFor(e.prefix), `${e.prefix}${e.lineNum} `);
	// When no language is known, keep the built-in look: whole line in the diff color.
	const body = (e: DiffEntry, styled: string | undefined, plain: string) =>
		lang ? (styled ?? plain) : theme.fg(colorFor(e.prefix), plain);

	const out: string[] = [];
	let oi = 0;
	let ni = 0;
	let i = 0;
	while (i < entries.length) {
		const e = entries[i];
		if (!e || isMarker(e)) {
			out.push(theme.fg("toolDiffContext", rawLines[i]));
			i++;
			continue;
		}
		if (e.prefix === "-") {
			const removed: { e: DiffEntry; plain: string; styled: string | undefined }[] = [];
			while (i < entries.length) {
				const p = entries[i];
				if (!p || p.prefix !== "-" || isMarker(p)) break;
				removed.push({ e: p, plain: oldBuf[oi], styled: oldHi[oi] });
				oi++;
				i++;
			}
			const added: { e: DiffEntry; plain: string; styled: string | undefined }[] = [];
			while (i < entries.length) {
				const p = entries[i];
				if (!p || p.prefix !== "+" || isMarker(p)) break;
				added.push({ e: p, plain: newBuf[ni], styled: newHi[ni] });
				ni++;
				i++;
			}
			if (removed.length === 1 && added.length === 1) {
				// Single-line modification: inverse-video the changed span (diffs.nvim style).
				const span = changedSpan(removed[0].plain, added[0].plain);
				const rBody = withInverseRange(body(removed[0].e, removed[0].styled, removed[0].plain), span.aStart, span.aEnd);
				const aBody = withInverseRange(body(added[0].e, added[0].styled, added[0].plain), span.bStart, span.bEnd);
				out.push(tint(gutter(removed[0].e) + rBody, removedBg));
				out.push(tint(gutter(added[0].e) + aBody, addedBg));
			} else {
				for (const r of removed) out.push(tint(gutter(r.e) + body(r.e, r.styled, r.plain), removedBg));
				for (const a of added) out.push(tint(gutter(a.e) + body(a.e, a.styled, a.plain), addedBg));
			}
			continue;
		}
		if (e.prefix === "+") {
			out.push(tint(gutter(e) + body(e, newHi[ni], newBuf[ni]), addedBg));
			ni++;
			i++;
			continue;
		}
		// Context line: present in both buffers; render the new-side styling.
		out.push(gutter(e) + body(e, newHi[ni], newBuf[ni]));
		oi++;
		ni++;
		i++;
	}
	return out.join("\n");
}

// ---------------------------------------------------------------------------
// Edit tool chrome (mirrors the built-in call component, with a styled body)
// ---------------------------------------------------------------------------

type EditPreview = { diff: string; firstChangedLine?: number } | { error: string };

/** The built-in call component is a Box augmented with preview bookkeeping fields. */
type EditCallComponent = Box & {
	preview?: EditPreview;
	previewArgsKey?: string;
	previewPending: boolean;
	settledError: boolean;
};

type RenderState = {
	callComponent?: EditCallComponent;
	settled?: boolean;
};

function rawPathOf(args: any): string | undefined {
	if (typeof args?.path === "string") return args.path;
	if (typeof args?.file_path === "string") return args.file_path;
	return undefined;
}

function pathDisplay(args: any, theme: Theme, cwd: string): string {
	const raw = rawPathOf(args);
	if (raw === undefined) return theme.fg("error", "[invalid arg]");
	if (!raw) return theme.fg("toolOutput", "...");
	const home = homedir();
	const short = raw.startsWith(home) ? `~${raw.slice(home.length)}` : raw;
	const styled = theme.fg("accent", short);
	if (!getCapabilities().hyperlinks) return styled;
	return hyperlink(styled, pathToFileURL(resolve(cwd, raw)).href);
}

function formatTitle(args: any, theme: Theme, cwd: string): string {
	return `${theme.fg("toolTitle", theme.bold("edit"))} ${pathDisplay(args, theme, cwd)}`;
}

function headerBg(preview: EditPreview | undefined, settledError: boolean, theme: Theme) {
	if (preview) {
		if ("error" in preview) return (text: string) => theme.bg("toolErrorBg", text);
		return (text: string) => theme.bg("toolSuccessBg", text);
	}
	if (settledError) return (text: string) => theme.bg("toolErrorBg", text);
	return (text: string) => theme.bg("toolPendingBg", text);
}

function surroundBgName(
	preview: EditPreview | undefined,
	settledError: boolean,
): "toolSuccessBg" | "toolErrorBg" | "toolPendingBg" {
	if (preview) return "error" in preview ? "toolErrorBg" : "toolSuccessBg";
	return settledError ? "toolErrorBg" : "toolPendingBg";
}

function rebuildHighlighted(component: EditCallComponent, args: any, theme: Theme, cwd: string): void {
	component.setBgFn(headerBg(component.preview, component.settledError, theme));
	component.clear();
	component.addChild(new Text(formatTitle(args, theme, cwd), 0, 0));
	if (!component.preview) return;
	component.addChild(new Spacer(1));
	const body =
		"error" in component.preview
			? theme.fg("error", component.preview.error)
			: renderHighlightedDiff(
					component.preview.diff,
					rawPathOf(args),
					theme,
					surroundBgName(component.preview, component.settledError),
				);
	component.addChild(new Text(body, 0, 0));
}

function previewArgsKey(args: any): string | undefined {
	const path = rawPathOf(args);
	if (!path) return undefined;
	if (Array.isArray(args?.edits) && args.edits.every((e: any) => typeof e?.oldText === "string" && typeof e?.newText === "string")) {
		return JSON.stringify({ path, edits: args.edits });
	}
	if (typeof args?.oldText === "string" && typeof args?.newText === "string") {
		return JSON.stringify({ path, edits: [{ oldText: args.oldText, newText: args.newText }] });
	}
	return undefined;
}

function resultText(result: { content?: { type: string; text?: string }[] }): string {
	return (result.content ?? [])
		.filter((c) => c.type === "text")
		.map((c) => c.text || "")
		.join("\n");
}

// ---------------------------------------------------------------------------
// Extension entry point
// ---------------------------------------------------------------------------

export default function (pi: ExtensionAPI) {
	const cwd = process.cwd();
	const base = createEditToolDefinition(cwd);

	pi.registerTool({
		...base,

		renderCall(args: any, theme: Theme, context: any) {
			// Keep the built-in live preview while streaming/executing.
			const component = base.renderCall!(args, theme, context) as EditCallComponent;
			// After settle, re-assert the highlighted body on any call-slot rerender.
			const state = context.state as RenderState;
			if (state.settled && state.callComponent) {
				rebuildHighlighted(state.callComponent, args, theme, context.cwd);
			}
			return component;
		},

		renderResult(result: any, _options: any, theme: Theme, context: any) {
			const state = context.state as RenderState;
			const callComponent = state.callComponent;
			const details = result.details as EditToolDetails | undefined;
			const resultDiff = !context.isError ? details?.diff : undefined;

			if (callComponent) {
				if (typeof resultDiff === "string") {
					callComponent.preview = { diff: resultDiff, firstChangedLine: details?.firstChangedLine };
					callComponent.previewArgsKey = previewArgsKey(context.args);
				}
				callComponent.settledError = context.isError;
				state.settled = true;
				rebuildHighlighted(callComponent, context.args, theme, context.cwd);
			}

			const component = (context.lastComponent as Container | undefined) ?? new Container();
			component.clear();

			if (context.isError) {
				const errorText = resultText(result);
				const previewError =
					callComponent?.preview && "error" in callComponent.preview ? callComponent.preview.error : undefined;
				if (errorText && errorText !== previewError) {
					component.addChild(new Spacer(1));
					component.addChild(new Text(theme.fg("error", errorText), 1, 0));
				}
			} else if (!callComponent && typeof resultDiff === "string") {
				// No call component (non-interactive rendering): show the diff here.
				component.addChild(new Spacer(1));
				component.addChild(new Text(renderHighlightedDiff(resultDiff, rawPathOf(context.args), theme), 1, 0));
			}
			return component;
		},
	});
}
