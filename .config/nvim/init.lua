local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

require("options")
require("lazy").setup("plugins")
require("keymaps").setup()
require("autocommands")

vim.api.nvim_create_user_command("Kochiku", function(opts)
	local command = "!sq kochiku"
	if #opts.fargs > 0 then
		command = string.format("%s %s", command, table.concat(opts.fargs, " "))
	end
	vim.cmd(command)
end, {
	nargs = "?",
	force = true,
	complete = function()
		return { "--canary" }
	end,
})
vim.api.nvim_create_user_command("Migrate", function()
	vim.cmd("!rails db:migrate && rails db:migrate RAILS_ENV=test")
end, {})
