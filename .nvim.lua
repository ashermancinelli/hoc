local source = debug.getinfo(1, "S").source
local project_root = vim.fs.dirname(vim.fs.abspath(source:sub(2)))

-- Load this repository's LSP overrides before enabling Tinymist.
vim.opt.runtimepath:append(project_root .. "/.nvim")
vim.lsp.enable("tinymist")
