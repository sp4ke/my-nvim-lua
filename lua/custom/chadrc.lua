-- Just an example, supposed to be placed in /lua/custom/

local M = {}

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:
--
-- local custom_theme = require("sp4ke.theme")
-- vim.tbl_deep_extend("force", M.ui.hl_add, custom_theme)

M.ui = {
  theme = "monekai",
  theme_toggle = { "monekai", "blossom" },
  hl_override = {
    DiagnosticWarn = {
      fg = "yellow",
      italic = true,
    },
    St_LspWarning = {
      fg = "yellow"
    },
    DiagnosticHint = {
      fg = "purple",
      italic = true,
    },
    St_LspHints = {
      fg = "pruple",
    },
    DiagnosticError = {
      italic = true,
    },
    St_LspInfo = {
      fg = "white"
    },
  },
  hl_add = {
    Visual = {
      bg = "blue",
      fg = "black",
    },
    BookmarkSign = {
      fg = "blue",
    },
    BookmarkAnnotationSign   = {
      fg = "yellow",
    },
    BookmarkAnnotationLine = {
      fg = "black",
      bg = "yellow"
    },
    DiagnosticInfo = { -- nvchad uses DiagnosticInformation wrong hi group for lsp
      fg = "white",
      italic = true,
    },
    DiagnosticFloatingInfo = {
      fg="white",
      italic=true,
    },
    DiagnosticUnderlineError = {
      fg="black",
      bg="pink",
    },
    -- Code Lens related colors
     LspCodeLens = {
      fg = "vibrant_green",
      underline = true,
    },
    LspDiagnosticsSignHint = { -- LspDiagnostics Code Action
      fg = "vibrant_green",
      italic = true,
    },
    -- end of code lens colors
    DiffText = {
      bg = "vigrant_green"
    },
    St_DapMode = {
      fg = "black2",
      bg = "baby_pink",
    },
    St_DapModeSep = {
      fg = "baby_pink",
      bg = "one_bg3",
    },
    St_DapModeSep2 = {
      fg = "grey",
      bg = "baby_pink",
    },
  },
  -- hl_override = {
  --   CursorLine = {
  --     underline = 1
  --   }
  -- },
  myicons = {
    lsp = {
      diagnostic_head = '',   -- default diagnostic head on dialogs
      diagnostic_err =  '',    -- severity 1
      diagnostic_warn = '',   --          2
      diagnostic_info = '',   --          3
      diagnostic_hint = '',   --          4
    }
  },
}

M.plugins = {
  user = require "custom.plugins",
  override = {
    ["folke/which-key.nvim"] = {
      triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        i = { "j", "k" },
        v = { "j", "k" },
      },
    },
    ["NvChad/ui"] = {
      -- tabufline = {
        --   lazyload = false,
        -- },
        statusline = {
          overriden_modules = function()
            return require "custom.plugins.nvchadui"
          end
        }


      },
      ["windwp/nvim-autopairs"] = {
        disable_filetype = {
          "TelescopePrompt",
          "vim",
          "guihua",
          "guihua_rust",
          "clap_input"
        }
      },
      ["nvim-treesitter/nvim-treesitter"] = require "custom.plugins.configs.treesitter",
    }
}

return M
