-- vim: foldlevel=1
--
-- TODO: interesting plugins to install
-- - neovim minisurround to replace vim-surround
--
-- #### notes on Lua and requiring modules
-- https://github.com/wbthomason/packer.nvim/issues/955
-- - when you require(...) a file in lua, it gets cached, so future require calls don't hit the filesystem.
-- This means reloading your lua config won't apply any changes because the old files are cached.
-- - Cached required modules are stored in `package.loaded` table
-- - for example if `require("foo.bar")` was issued it's cache would be in
--   `package.loaded["foo.bar"]`
--
-- - to remove the cached module
--
--   lua << EOF
--
--     for k, v in pairs(package.loaded) do
--       if string.match(k, "^my_lua_config") then
--         package.loaded[k] = nil
--       end
--     end
--
--   EOF
--
-- #### Proper way to reload packer while picking up all changes from configs/setup
-- - Remove the cached module using package.loaded["foo.bar"] = nil
-- - Execute :PackerCompile
--
-- This doesn't seem to work:
-- - XXX ~~Reload all lua modules with `"pleanery.reload".reload_module(mod)`~~ XXX

return {


  -- My Plugins

  -- ["~/.config/nvim/my_packages/perproject"] = {-- {{{
  --   opt = true,
  --   after = {"nvim-lspconfig", "navigator.lua"},
  --   require = {"nvim-lspconfig", "navigator.lua"},
  --   config = function()
  --     require("perproject").setup()
  --       -- callbacks = {
  --       --   foo = function()
  --       --     print("FOO")
  --       --   end
  --       -- }
  --     -- })
  --   end
  -- },-- }}}


  -- treesitter

  ["nvim-treesitter/nvim-treesitter"] = {-- {{{
    setup =  function()
      require("core.lazy_load").on_file_open "nvim-treesitter"
      require("core.lazy_load").on_file_open "nvim-treesitter-textobjects"
      require("core.lazy_load").on_file_open "nvim-treesitter-textsubjects"
      require("core.lazy_load").on_file_open "nvim-treesitter-context"
      -- require("core.lazy_load").on_file_open "nvim-ts-rainbow"
    end,
  },
  ["nvim-treesitter/nvim-treesitter-textobjects"] = {
    opt = true,
  },
  ["RRethy/nvim-treesitter-textsubjects"] = {
    opt = true,
  },

  -- Treesitter dev/exploration tool
  ["nvim-treesitter/playground"] = {
    opt = true,
  },

  ["nvim-treesitter/nvim-treesitter-context"] = {
    opt = true,
    config = function()
      require("custom.plugins.configs.treesitter-context").setup()
    end
  },-- }}}


  -- autocomplete

  ["hrsh7th/cmp-buffer"] = {-- {{{
    config = function ()
      local disabled_ft = {
        "guihua",
        "clap_input",
        "guihua_rust,",
        "TelescopePrompt"
      }

      require("cmp").setup.buffer {
        enabled = function ()
          for _, v in ipairs(disabled_ft) do
            if vim.o.ft == v then return false end
          end
          return true
        end
      }
    end
  },-- }}}

  -- snippets 
  ["honza/vim-snippets"] = {-- {{{
    module = {"cmp", "cmp_nvim_lsp"},
    event = "InsertEnter",
  },

  ["L3MON4D3/LuaSnip"] = {
    lock = false,
    config = function()
      -- load default config first
      require("plugins.configs.others").luasnip()

      vim.g.my_snippets_paths = {"./custom_snippets"}
      require("luasnip").filetype_extend("markdown", { "markdown_zk" })

      -- load snippets from "honza/vim-snippets"
      -- includes ultisnips and snipmate snippets
      require("luasnip.loaders.from_snipmate").lazy_load({ override_priority = 800 })
      require("luasnip.loaders.from_snipmate").lazy_load {
        paths = vim.g.my_snippets_paths,
        override_priority = 800
      }
    end
  },-- }}}

  -- text formatting

  ["folke/todo-comments.nvim"] = { -- {{{
    after = "nvim-treesitter",
    config = function()
      require("custom.plugins.configs.todo-comments").setup()
    end
  },

  ["tpope/vim-surround"] = {},

  ["godlygeek/tabular"] = {
    cmd = "Tabularize"
  },-- }}}


  -- ["p00f/nvim-ts-rainbow"] = {
  --   opt = true,
  -- },
  --

  -- dap

  ["mfussenegger/nvim-dap"] = {-- {{{
    lock = true,
    module = "dap",
    setup = function()
      require("core.utils").load_mappings "dap"
    end,
  },

  ["rcarriga/nvim-dap-ui"] = {
    lock = true,
    after = "nvim-dap",
  },

  ["theHamsta/nvim-dap-virtual-text"] = {
    lock = true,
    after = "nvim-dap"
  },-- }}}

  -- User Interface / UX

  ["folke/which-key.nvim"] = {-- {{{
    lock = true,
    disable = false,
    keys = {"<leader>", "<BS>", "<Space>"}
  },

  -- repeat operator for plugin commands
  ["tpope/vim-repeat"] = {
    keys = {"."},
  },

  ["nvim-telescope/telescope.nvim"] = {
    -- lock = true,
    tag = "*",
    disable = false,
  },
  ["tom-anders/telescope-vim-bookmarks.nvim"] = {
    opt = true,
    module = "telescope",
    after = {"telescope.nvim", "vim-bookmarks"},
    -- cmd = "Telescope",
    -- requires = "vim-bookmarks",
    -- after = {"vim-bookmarks", "telescope"},
    -- module = "telescope",
    config = function()
      require("telescope").load_extension("vim_bookmarks")
    end
  },
  ["nvim-telescope/telescope-fzf-native.nvim"] = {
    opt = true,
    module = "telescope",
    after = {"telescope.nvim"},
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
  },
  ["ibhagwan/fzf-lua"] = {
    lock = true,
    after = "ui",
    config = function()
      require("custom.plugins.configs.fzflua")
      require("plugins.configs.others").devicons()
    end,
    setup = function()
      require("core.utils").load_mappings "fzf_lua"
    end
  },-- }}}


  -- navigation / jumps

  ["ggandor/leap.nvim"] = {-- {{{
    config = function()
      require "custom.plugins.configs.leap"
    end
  },-- }}}


  -- Job management (use nvim startjob )
  -- Run async commands (make & errors)

  ["skywind3000/asyncrun.vim"] = {-- {{{
    lock = true,
    cmd = "AsyncRun",
    setup = function()
      require("core.utils").load_mappings "asyncrun"
      vim.g.asyncrun_open = 8
    end
  },-- }}}

  -- Git
  ["tpope/vim-fugitive"] = {
    cmd = {"G", "Git", "G*"}
  },

  -- session and view
  ["vim-scripts/restore_view.vim"] = {}, -- TODO: check if still needed

  -- ["rmagatti/auto-session"] = {
  --   config = function ()
  --       require("auto-session").setup {
  --         log_level = "error",
  --         auto_session_suppress_dirs = {"~/", "~/projects", "/"},
  --         auto_save_enabled = false,
  --       }
  --   end
  -- },

  -- text formatting and navigation

  -- ["justinmk/vim-sneak"] = {
  --   lock = true,
  --   keys = {"s", "S"},
  -- },

  --
  -- Misc / General plugins

  -- Read info files
  ["https://gitlab.com/HiPhish/info.vim.git"] = {
    cmd = "Info",
  },


  ["MattesGroeger/vim-bookmarks"] = {
    config = function()
      require("core.utils").load_mappings "vim_bookmarks"
    end
  },

  -- create new vim modes
  ["Iron-E/nvim-libmodal"] = {
    lock = true,
  },

  -- get rid of bad habits
  ["takac/vim-hardtime"] = {
    setup = function()
      vim.g.hardtime_default_on = 1
      vim.g.hardtime_showmsg = 1
    end
  },

  -- ["chentoast/marks.nvim"] = {
  --   opt = true,
  --   keys = {"m", "d"},
  --   cmd = {"Marks*", "Bookmarks*"},
  --   config = function ()
  --     require("custom.plugins.configs.marks").setup()
  --   end
  -- },

  -- ------------------
  -- LSP 
  -- ------------------

  ["neovim/nvim-lspconfig"] = {-- {{{
    after = {"lua-dev.nvim", "mason.nvim", "mason-lspconfig.nvim"},
    module = {"lspconfig"},
    lock = false,
    config = function()
      require("plugins.configs.lspconfig").setup()
    end
  },
  ["williamboman/mason-lspconfig.nvim"] = {
    lock = false,
    requires = {"williamboman/mason.nvim", "nvim-lspconfig"},
    -- after = "mason.nvim",
    module = {"mson-lspconfig.nvim", "mason.nvim"},
    config = function()
      require("mason-lspconfig").setup({})
    end,
  },
  ["ray-x/guihua.lua"] = {
    lock = true,
    module = {"navigator"},
    run = "cd lua/fzy && make",
    config = function()
      require("guihua.maps").setup {
        maps = {
          close_view = "<C-x>",
        }
      }
    end

  },
  -- ["https://git.sp4ke.xyz/sp4ke/navigator.lua"] = 
    --
  ["ray-x/navigator.lua"] = {
    lock = true,
    opt = true,
    module = "navigator",
    after = { "nvim-lspconfig", "base46", "ui", "mason.nvim", "mason-lspconfig.nvim", "lua-dev.nvim" },
    requires =  {"neovim/nvim-lspconfig", "ray-x/guihua.lua", "nvim-treesitter/nvim-treesitter"},
    setup = function()
      require("core.lazy_load").on_file_open "navigator.lua"
      require("core.utils").load_mappings "navigator"
    end,
    config = function()
      require("custom.plugins.configs.navigator").setup()
      require("base46").load_highlight "lsp"

      -- TODO: use nvchadui_lsp features manually
      -- require("nvchad_ui.lsp")
    end
  },

  ["ray-x/lsp_signature.nvim"] = {
    lock = true,
    after = {"navigator.lua"},
    config = function()
      require("custom.plugins.configs.lsp_signature").setup()
    end

  },-- }}}

  -- side panel with symbols (replaced by Navigator :LspSymbols cmd)
  -- ["liuchengxu/vista.vim"] = {
  --   cmd = "Vista",
  --   setup = function()
  --     require("core.utils").load_mappings "vista"
  --   end
  -- },
  --

  -- -------------------------------------------------------
  -- Programming Languages Plugins
  -- -------------------------------------------------------

  -- -------
  -- lua dev
  -- -------

  -- Eval Lua lines/selections

  -- ["bfredl/nvim-luadev"] = {{{{
  --   lock = true,
  --   cmd = "Luadev",
  --   keys = {
  --     "<Plug>(Luadev-RunLine)",
  --     "<Plug>(Luadev-Run)",
  --     "<Plug>(Luadev-RunWord)",
  --     "<Plug>(Luadev-Complete)",
  --   },
  --   setup = function()
  --     local autocmd = vim.api.nvim_create_autocmd
  --     autocmd("FileType", {
  --       pattern = "lua",
  --       callback = function ()
  --         vim.keymap.set({'n', 'i'}, '<leader>r', '<Plug>(Luadev-RunLine)', {
  --           desc = "Luadev RunLine"
  --         })
  --       end,
  --     })
  --   end
  -- },}}}

  -- power Repl {{{
  ["hkupty/iron.nvim"] = {
    loack = true,
    cmd = {"Iron*"},
    setup = function()
      require("core.utils").load_mappings "iron"
    end,
    config = function()
      require("custom.plugins.configs.iron").setup()
    end 
  },

  -- REPL for Lua development
  ["ii14/neorepl.nvim"] = {
    lock = true,
    cmd = "Repl",
    after = "nvim-cmp",
    config = function ()
      local autocmd = vim.api.nvim_create_autocmd
      autocmd("FileType",{
        pattern = "neorepl",
        callback = function ()
          require('cmp').setup.buffer({enabled = false})

          -- custom keymap example
          -- activate corresponding section in mappings
          -- mappings = require("custom.utils").set_plugin_mappings "neorepl"
        end
      })
    end
  },

  -- Lua dev env
  -- check setup in configs/navigator.lua
  ["folke/lua-dev.nvim"] = {
    lock = true,
    module = "lua-dev",
  },-- }}}

  -- golang dev

  ["ray-x/go.nvim"] = {-- {{{
    lock = true,
    -- after = {"nvim-lspconfig", "navigator.lua", "guihua.lua"},
    ft = {"go"},
    opt = true,
    config = function()
      require("custom.plugins.configs.gonvim").setup()
    end
  }-- }}}

}
