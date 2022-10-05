local wk = require("which-key")

wk.setup({
  hidden = {
    "<silent>",
    "<cmd>",
    "<Cmd>",
    "<cr>",
    "<CR>",
    "call",
    "lua",
    "require",
    "^:",
    "^ ",
  }, -- hide mapping boilerplate
})


local default_options = { silent = true }

-- register non leader based mappings
wk.register({
  sa = "Add surrounding",
  sd = "Delete surrounding",
  sh = "Highlight surrounding",
  sn = "Surround update n lines",
  sr = "Replace surrounding",
  sF = "Find left surrounding",
  sf = "Replace right surrounding",
  ss = { "<cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<cr>", "Jump to character" },
  st = { "<cmd>lua require('tsht').nodes()<cr>", "TS hint textobject" },
})

-- Register all leader based mappings
wk.register({
  ["<Tab>"] = { "<cmd>e#<cr>", "Prev buffer" },
  b = {
    name = "Buffers",
    b = {
      "<cmd>Telescope buffers<cr>",
      "Find buffer",
    },
    D = {
      "<cmd>%bd|e#|bd#<cr>",
      "Close all but the current buffer",
    },
    d = { "<cmd>lua MiniBufremove.delete()<CR>", "Close buffer" },
  },
  f = {
    name = "Files",
    b = { "<cmd>Telescope file_browser grouped=true<cr>", "File browser" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    p = { "<cmd>Neotree reveal toggle<cr>", "Toggle Filetree" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    s = { "<cmd>w<cr>", "Save Buffer" },
  },
  g = { "Git" },
  m = {
    name = "Misc",
    o = { "Options" },
    p = { "<cmd>PackerSync --preview<cr>", "PackerSync" },
    s = { "<cmd>SymbolsOutline<cr>", "Toggle SymbolsOutline" },
  },

  s = { "Search" },
  w = { "Windows" },

}, { prefix = "<leader>", mode = "n", default_options})
