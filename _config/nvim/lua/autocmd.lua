local api = vim.api

-- automatically run PackerSync on save of plugins.lua
-- source plugins.lua and run PackerSync on save
local sync_packer = function()
  vim.cmd("runtime lua/plugins.lua")
  require("packer").sync()
end
api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "plugins.lua" },
  callback = sync_packer,
})
