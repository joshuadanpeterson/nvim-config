-- init.lua


-- Custom configs
require('config.settings') -- For basic Neovim settings

-- lazy.nvim setup
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ configure plugins ]]
require('lazy').setup({
  -- note: first, some plugins that don't require any configuration

    -- legendary.nvim
  {
  'mrjones2014/legendary.nvim',
  -- since legendary.nvim handles all your keymaps/commands,
  -- its recommended to load legendary.nvim before other plugins
  priority = 10000,
  lazy = false,
  -- sqlite is only needed if you want to use frecency sorting
  dependencies = { 'kkharji/sqlite.lua' }
  },

  -- import custom plugins
  { import = 'custom.plugins' },
  { import = 'kickstart.plugins' },

})

-- Custom configs
require('config.keymaps') -- For keybindings managed with which-key
require('config.cmp') -- For autocomplete config
require('config.tmux') -- For Tmux navigation
require('config.conform') -- For conform.nvim

-- Plugin Manager Setup

-- Setup legendary.nvim
-- Automatically loads keymaps
require('legendary').setup({
  -- Initial keymaps to bind, can also be a function that returns the list
  keymaps = {},
  -- Initial commands to bind, can also be a function that returns the list
  commands = {},
  -- Initial augroups/autocmds to bind, can also be a function that returns the list
  autocmds = {},
  -- Initial functions to bind, can also be a function that returns the list
  funcs = {},
  -- Initial item groups to bind,
  -- note that item groups can also
  -- be under keymaps, commands, autocmds, or funcs;
  -- can also be a function that returns the list
  itemgroups = {},
  -- default opts to merge with the `opts` table
  -- of each individual item
  default_opts = {
    -- for example, { silent = true, remap = false }
    keymaps = {},
    -- for example, { args = '?', bang = true }
    commands = {},
    -- for example, { buf = 0, once = true }
    autocmds = {},
  },
  -- Customize the prompt that appears on your vim.ui.select() handler
  -- Can be a string or a function that returns a string.
  select_prompt = ' legendary.nvim ',
  -- Character to use to separate columns in the UI
  col_separator_char = '│',
  -- Optionally pass a custom formatter function. This function
  -- receives the item as a parameter and the mode that legendary
  -- was triggered from (e.g. `function(item, mode): string[]`)
  -- and must return a table of non-nil string values for display.
  -- It must return the same number of values for each item to work correctly.
  -- The values will be used as column values when formatted.
  -- See function `default_format(item)` in
  -- `lua/legendary/ui/format.lua` to see default implementation.
  default_item_formatter = nil,
  -- Customize icons used by the default item formatter
  icons = {
    -- keymap items list the modes in which the keymap applies
    -- by default, you can show an icon instead by setting this to
    -- a non-nil icon
    keymap = nil,
    command = '',
    fn = '󰡱',
    itemgroup = '',
  },
  -- Include builtins by default, set to false to disable
  include_builtin = true,
  -- Include the commands that legendary.nvim creates itself
  -- in the legend by default, set to false to disable
  include_legendary_cmds = true,
  -- Options for list sorting. Note that fuzzy-finders will still
  -- do their own sorting. For telescope.nvim, you can set it to use
  -- `require('telescope.sorters').fuzzy_with_index_bias({})` when
  -- triggered via `legendary.nvim`. Example config for `dressing.nvim`:
  --
  require('dressing').setup({
   select = {
     get_config = function(opts)
       if opts.kind == 'legendary.nvim' then
         return {
           telescope = {
             sorter = require('telescope.sorters').fuzzy_with_index_bias({})
           }
         }
       else
         return {}
       end
     end
   }
  }),
  sort = {
    -- put most recently selected item first, this works
    -- both within global and item group lists
    most_recent_first = true,
    -- sort user-defined items before built-in items
    user_items_first = true,
    -- sort the specified item type before other item types,
    -- value must be one of: 'keymap', 'command', 'autocmd', 'group', nil
    item_type_bias = nil,
    -- settings for frecency sorting.
    -- https://en.wikipedia.org/wiki/Frecency
    -- Set `frecency = false` to disable.
    -- this feature requires sqlite.lua (https://github.com/kkharji/sqlite.lua)
    -- and will be automatically disabled if sqlite is not available.
    -- NOTE: THIS TAKES PRECEDENCE OVER OTHER SORT OPTIONS!
    frecency = {
      -- the directory to store the database in
      db_root = string.format('%s/legendary/', vim.fn.stdpath('data')),
      -- the maximum number of timestamps for a single item
      -- to store in the database
      max_timestamps = 10,
    },
  },
  -- Which extensions to load; no extensions are loaded by default.
  -- Setting the plugin name to `false` disables loading the extension.
  -- Setting it to any other value will attempt to load the extension,
  -- and pass the value as an argument to the extension, which should
  -- be a single function. Extensions are modules under `legendary.extensions.*`
  -- which return a single function, which is responsible for loading and
  -- initializing the extension.
  extensions = {
    nvim_tree = false,
    smart_splits = false,
    op_nvim = false,
    diffview = false,
    lazy_nvim = true,
    which_key = {
      -- Automatically add which-key tables to legendary
      -- see ./doc/WHICH_KEY.md for more details
      auto_register = true,
      -- you can put which-key.nvim tables here,
      -- or alternatively have them auto-register,
      -- see ./doc/WHICH_KEY.md
      mappings = {},
      opts = {},
      -- controls whether legendary.nvim actually binds they keymaps,
      -- or if you want to let which-key.nvim handle the bindings.
      -- if not passed, true by default
      do_binding = true,
      -- controls whether to use legendary.nvim item groups
      -- matching your which-key.nvim groups; if false, all keymaps
      -- are added at toplevel instead of in a group.
      use_groups = true,
    }
  },
  scratchpad = {
    -- How to open the scratchpad buffer,
    -- 'current' for current window, 'float'
    -- for floating window
    view = 'float',
    -- How to show the results of evaluated Lua code.
    -- 'print' for `print(result)`, 'float' for a floating window.
    results_view = 'float',
    -- Border style for floating windows related to the scratchpad
    float_border = 'rounded',
    -- Whether to restore scratchpad contents from a cache file
    keep_contents = true,
  },
  -- Directory used for caches
  cache_path = string.format('%s/legendary/', vim.fn.stdpath('cache')),
  -- Log level, one of 'trace', 'debug', 'info', 'warn', 'error', 'fatal'
  log_level = 'info',
})

require 'lspconfig'.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        lua = {
          runtime = {
            -- tell the language server which version of lua you're using
            -- (most likely luajit in the case of neovim)
            version = 'luajit'
          },
          -- make the server aware of neovim runtime files
          workspace = {
            checkthirdparty = false,
            library = {
              vim.env.vimruntime
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
            -- or pull in all of 'runtimepath'. note: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          }
        }
      })

      client.notify("workspace/didchangeconfiguration", { settings = client.config.settings })
    end
    return true
  end
}

-- configure 'nvim-lint'
require('lint').linters_by_ft = {
  lua = { 'luacheck' }
}

vim.api.nvim_create_autocmd({ "bufwritepost" }, {
  pattern = { "*.lua" },
  callback = function()
    require('lint').try_lint()
  end,
})

-- note: next step on your neovim journey: add/configure additional "plugins" for kickstart
--       these are some example plugins that i've included in the kickstart repository.
--       uncomment any of the lines below to enable them.
require 'kickstart.plugins.autoformat'
require 'kickstart.plugins.debug'

-- [[ highlight on yank ]]
-- see `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('yankhighlight', { clear = true })
vim.api.nvim_create_autocmd('textyankpost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
-- [[ configure telescope ]]
-- see `:help telescope` and `:help telescope.setup()`
local icons = require("nvim-nonicons")
require('telescope').setup({
  defaults = {
    prompt_prefix = "  " .. icons.get("telescope") .. "  ",
    selection_caret = " ❯ ",
    entry_prefix = "   ",
    mappings = {
      i = {
        ['<c-u>'] = false,
        ['<c-d>'] = false,
      -- enable mouse support in telescope window
        ['<c-n>'] = "move_selection_next",
        ['<c-p>'] = "move_selection_previous",
      -- add mouse support for scrolling and selection
        ["<leftmouse>"] = "select_default",
        ["<scrollwheelup>"] = "preview_scrolling_up",
        ["<scrollwheeldown>"] = "preview_scrolling_down",
      },
    },
  },
  pickers = {
  },
  extensions = {
    dash = {
      -- configure path to dash.app if installed somewhere other than /applications/dash.app
      dash_app_path = '/applications/dash.app',
      -- search engine to fall back to when dash has no results, must be one of: 'ddg', 'duckduckgo', 'startpage', 'google'
      search_engine = 'google',
      -- debounce while typing, in milliseconds
      debounce = 20,
      -- map filetype strings to the keywords you've configured for docsets in dash
      -- setting to false will disable filtering by filetype for that filetype
      -- filetypes not included in this table will not filter the query by filetype
      -- check src/lua_bindings/dash_config_binding.rs to see all defaults
      -- the values you pass for file_type_keywords are merged with the defaults
      -- to disable filtering for all filetypes,
      -- set file_type_keywords = false
      file_type_keywords = {
        dashboard = false,
        telescopeprompt = true,
        terminal = false,
        packer = false,
        fzf = false,
        -- a table of strings will search on multiple keywords
        javascript = { 'javascript', 'nodejs' },
        typescript = { 'typescript', 'javascript', 'nodejs' },
        typescriptreact = { 'typescript', 'javascript', 'react' },
        javascriptreact = { 'javascript', 'react' },
        -- you can also do a string, for example,
        sh = 'bash'
      },
    },
  },
})


-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep({
      search_dirs = { git_root },
    })
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'json', 'css', 'markdown', 'markdown_inline' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = true,

    highlight = { enable = true },
    autotag = { enable = true },
    playground = { enable = true },
    rainbow = {
      enable = true,
      extended_mode = true, -- Also highlight other brackets/parentheses
    },
    -- Which query to use for finding delimiters
    query = 'rainbow-parens',
    -- Highlight the entire buffer all at once
    strategy = require('ts-rainbow').strategy.global,
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- Key mappings or other buffer-specific settings go here
  -- Example of setting a keymap with bufnr:
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',
    { noremap = true, silent = true })
  -- ... more configurations
end
-- NOTE: Remember that lua is a real programming language, and as such it is possible
-- to define small helper and utility functions so you don't have to repeat yourself
-- many times.

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.

-- Load Neovim's built-in LSP configuration module
local lspconfig = require('lspconfig')

-- Configure Jedi Language Server
lspconfig.jedi_language_server.setup {
  on_attach = on_attach, -- assuming you have an `on_attach` function as shown in your config
  flags = {
    debounce_text_changes = 150,
  }
}

-- TypeScript and JavaScript LSP configuration
lspconfig.tsserver.setup {
  on_attach = function(_client, _bufnr)
    -- Your custom on_attach function
    -- (e.g., key mappings for LSP functions)
  end,
  -- Additional LSP settings can be added here
}

--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- Setup LSP Configurations for `nvim-cmp`
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}


-- Example: Setting up Lua LSP
require 'lspconfig'.lua_ls.setup {
  capabilities = capabilities,
}

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }
  })
})

-- Integrates autopairs into Autocompletion
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))

-- [[ Configure Harpoon Telescope ]]
local harpoon = require('harpoon')
harpoon:setup({})

-- basic telescope-ui configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

vim.keymap.set("n", "<leader>e", function() toggle_telescope(harpoon:list()) end,
  { desc = "Open harpoon window" })

-- noice
require("telescope").load_extension("noice")

-- multicursors.nvim Status Line module
require('multicursors').setup {
  hint_config = false,
}

-- fidget.nvim
require('fidget').setup({
    -- Options related to LSP progress subsystem
  progress = {
    poll_rate = 0,                -- How and when to poll for progress messages
    suppress_on_insert = false,   -- Suppress new messages while in insert mode
    ignore_done_already = false,  -- Ignore new tasks that are already complete
    ignore_empty_message = false, -- Ignore new tasks that don't contain a message
    clear_on_detach =             -- Clear notification group when LSP server detaches
      function(client_id)
        local client = vim.lsp.get_client_by_id(client_id)
        return client and client.name or nil
      end,
    notification_group =          -- How to get a progress message's notification group key
      function(msg) return msg.lsp_client.name end,
    ignore = {},                  -- List of LSP servers to ignore

    -- Options related to how LSP progress messages are displayed as notifications
    display = {
      render_limit = 16,          -- How many LSP messages to show at once
      done_ttl = 3,               -- How long a message should persist after completion
      done_icon = "✔",            -- Icon shown when all LSP progress tasks are complete
      done_style = "Constant",    -- Highlight group for completed LSP tasks
      progress_ttl = math.huge,   -- How long a message should persist when in progress
      progress_icon =             -- Icon shown when LSP progress tasks are in progress
        { pattern = "dots", period = 1 },
      progress_style =            -- Highlight group for in-progress LSP tasks
        "WarningMsg",
      group_style = "Title",      -- Highlight group for group name (LSP server name)
      icon_style = "Question",    -- Highlight group for group icons
      priority = 30,              -- Ordering priority for LSP notification group
      format_message =            -- How to format a progress message
        require("fidget.progress.display").default_format_message,
      format_annote =             -- How to format a progress annotation
        function(msg) return msg.title end,
      format_group_name =         -- How to format a progress notification group's name
        function(group) return tostring(group) end,
      overrides = {               -- Override options from the default notification config
        rust_analyzer = { name = "rust-analyzer" },
      },
    },

    -- Options related to Neovim's built-in LSP client
    lsp = {
      progress_ringbuf_size = 0,  -- Configure the nvim's LSP progress ring buffer size
    },
  },

  -- Options related to notification subsystem
  notification = {
    poll_rate = 10,               -- How frequently to update and render notifications
    filter = vim.log.levels.INFO, -- Minimum notifications level
    override_vim_notify = false,  -- Automatically override vim.notify() with Fidget
    configs =                     -- How to configure notification groups when instantiated
      { default = require("fidget.notification").default_config },

    -- Options related to how notifications are rendered as text
    view = {
      stack_upwards = true,       -- Display notification items from bottom to top
      icon_separator = " ",       -- Separator between group name and icon
      group_separator = "---",    -- Separator between notification groups
      group_separator_hl =        -- Highlight group used for group separator
        "Comment",
    },

    -- Options related to the notification window and buffer
    window = {
      normal_hl = "Comment",      -- Base highlight group in the notification window
      winblend = 100,             -- Background color opacity in the notification window
      border = "none",            -- Border around the notification window
      zindex = 45,                -- Stacking priority of the notification window
      max_width = 0,              -- Maximum width of the notification window
      max_height = 0,             -- Maximum height of the notification window
      x_padding = 1,              -- Padding from right edge of window boundary
      y_padding = 0,              -- Padding from bottom edge of window boundary
      align = "bottom",           -- How to align the notification window
      relative = "editor",        -- What the notification window position is relative to
    },
  },

  -- Options related to logging
  logger = {
    level = vim.log.levels.WARN,  -- Minimum logging level
    float_precision = 0.01,       -- Limit the number of decimals displayed for floats
    path =                        -- Where Fidget writes its logs to
      string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
  },
})

-- Set color consistency w/Tmux
if vim.fn.exists('+termguicolors') == 1 then
  vim.api.nvim_set_option('t_8f', '\\<Esc>[38;2;%lu;%lu;%lum')
  vim.api.nvim_set_option('t_8b', '\\<Esc>[48;2;%lu;%lu;%lum')
  vim.opt.termguicolors = true
end

-- CODESTATS_API_KEY
local codestats_api_key = os.getenv("CODESTATS_API_KEY")
assert(codestats_api_key ~= nil, "CODESTATS_API_KEY is not set")
require('codestats-nvim').setup({
  token = codestats_api_key
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
