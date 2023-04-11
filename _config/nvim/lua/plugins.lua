-- returns the require for use in `config` parameter of packer's use
-- expects the name of the config file
local function get_config(name)
  return string.format('require("config/%s")', name)
end

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local packer = require('packer')


packer.init({
  enable = true, -- enable profiling via :PackerCompile profile=true
  threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
  max_jobs = 20, -- Limit the number of simultaneous jobs. nil means no limit. Set to 20 in order to prevent PackerSync form being "stuck" -> https://github.com/wbthomason/packer.nvim/issues/746
  -- Have packer use a popup window
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    branch = "0.1.x",
    requires = {
      "nvim-lua/plenary.nvim"
    },
    config = get_config("telescope"),
  }

  use({ "crispgm/telescope-heading.nvim" })
  use({ "nvim-telescope/telescope-symbols.nvim" })
  use({ "nvim-telescope/telescope-file-browser.nvim" })
  use({ "nvim-telescope/telescope-packer.nvim" })
  use({ "nvim-telescope/telescope-ui-select.nvim" })

  -- Treesitter and related syntax tools
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      {
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        "s1n7ax/nvim-window-picker",
        config = get_config("nvim-window-picker"),
      },
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = get_config("neo-tree"),
  }

  use({ "windwp/nvim-autopairs", config = get_config("nvim-autopairs") })

  use({
    "nvim-treesitter/nvim-treesitter",
    config = get_config("treesitter"),
    run = ":TSUpdate",
  })

  use("nvim-treesitter/nvim-treesitter-textobjects")
  use("RRethy/nvim-treesitter-endwise")
  use({ "David-Kunz/markid" })
  use("p00f/nvim-ts-rainbow")
  use({ "mfussenegger/nvim-treehopper" })

  use({
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  })


  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-calc",
      "lukas-reineke/cmp-rg",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = get_config("cmp"),
  })

  use({ "rafamadriz/friendly-snippets" })
  use({
    "L3MON4D3/LuaSnip",
    requires = "saadparwaiz1/cmp_luasnip",
    config = get_config("luasnip"),
  })

  -- Git
  use({
    "TimUntersberger/neogit",
    requires = {
      "nvim-lua/plenary.nvim",
      {
        "sindrets/diffview.nvim",
        cmd = {
          "DiffviewOpen",
          "DiffviewClose",
          "DiffviewToggleFiles",
          "DiffviewFocusFiles",
        },
        config = get_config("git.diffview"),
      },
    },
    cmd = "Neogit",
    config = get_config("git.neogit"),
  })

  use({ "f-person/git-blame.nvim", config = get_config("git.git-blame") })

  use({
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = get_config("git.gitsigns"),
  })

  use { "tpope/vim-fugitive" }

  use({
    "kevinhwang91/nvim-bqf",
    requires = {
      "junegunn/fzf",
      module = "nvim-bqf",
    },
    ft = "qf",
    config = get_config("nvim-bqf"),
  })

  -- LSP and pals
  use({ "neovim/nvim-lspconfig", config = get_config("lsp.lsp") })

  use({ "onsails/lspkind-nvim" })

  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { { "nvim-lua/plenary.nvim" } },
    config = get_config("lsp.null-ls"),
  })

  use({
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline" },
    config = get_config("symbols-outline"),
  })

  use({
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = get_config("indent-blankline"),
  })

  use({
    "akinsho/nvim-toggleterm.lua",
    config = get_config("toggleterm"),
  })

  use({
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = get_config("todo"),
  })

  use "gpanders/editorconfig.nvim"

  use({ "ahmedkhalf/project.nvim", config = get_config("project") })

  use { "folke/which-key.nvim", config = get_config("which-key") }

  use({ "RRethy/vim-illuminate", config = get_config("illuminate") })

  use { "EdenEast/nightfox.nvim", config = get_config("themes.nightfox") }

  use({ "ray-x/go.nvim", requires = "ray-x/guihua.lua", config = get_config("go"), ft = { "go" } })

  use({ "rcarriga/nvim-notify", config = get_config("notify") })

  use { "echasnovski/mini.nvim", branch = "main", config = get_config("mini") }

  use({ "edluffy/specs.nvim", config = get_config("specs") })

  use({
    "goolord/alpha-nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = get_config("alpha.alpha"),
  })

  use({ "SmiteshP/nvim-navic" })

  use({
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({ window = {
        blend = 0,
      } })
    end,
  })

  use({
    "https://gitlab.com/yorickpeterse/nvim-pqf.git",
    config = function()
      require("pqf").setup()
    end,
  })

  use({
    "anuvyklack/hydra.nvim",
    requires = "anuvyklack/keymap-layer.nvim", -- needed only for pink hydras
    commit = "ea91aa820a6cecc57bde764bb23612fff26a15de",
    config = get_config("hydra"),
  })

  use({
    "mfussenegger/nvim-dap",
    requires = {
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require("config.dap").setup()
    end,
  })

  use({
    "aarondiel/spread.nvim",
    after = "nvim-treesitter",
    config = get_config("spread"),
  })

  use({
    "anuvyklack/windows.nvim",
    requires = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    config = get_config("windows"),
  })


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
