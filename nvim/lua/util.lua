local M = {}

function M.augroups(config)
	for group, commands in pairs(config) do
		vim.cmd("augroup " .. group)
		vim.cmd("au!")
		for _, cmd in pairs(commands) do
			vim.cmd("au " .. cmd)
		end
		vim.cmd("augroup END")
	end
end

return M
