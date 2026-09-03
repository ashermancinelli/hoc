local source = debug.getinfo(1, "S").source
local config_path = vim.fs.abspath(source:sub(2))
local project_root = vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(config_path)))

return {
  cmd = { "tinymist" },
  filetypes = { "typst" },
  root_dir = project_root,
  settings = {
    rootPath = project_root,
    typstExtraArgs = { "main.typ" },
  },
}
