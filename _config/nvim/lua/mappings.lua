-- more mappings are defined in `lua/config/which.lua`
local map = vim.keymap.set
local default_options = { silent = true }
local expr_options = { expr = true, silent = true }

--Remap space as leader key
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

-- Tab switch buffer
map("n", "<TAB>", ":bnext<CR>", default_options)
map("n", "<S-TAB>", ":bprev<CR>", default_options)
