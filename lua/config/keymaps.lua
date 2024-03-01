-- This config file contains my keymaps
-- lua/config/keymaps.lua

-- import dependencies
local wk = require("which-key")
local harpoon = require("harpoon")
local dap = require('dap')
local dapui = require('dapui')

-- set up lualine function
local function setup_lualine()
	-- Ensure this function contains your lualine setup configuration
	require('lualine').setup {
		-- Your lualine configuration goes here
	}
end

local function refresh_lualine()
	package.loaded['lualine'] = nil
	setup_lualine()
end

-- General and Basic Keymaps
local generalMappings = {
	['<Space>'] = { '<Nop>', "No Operation" },
	['k'] = { "v:count == 0 ? 'gk' : 'k'", "Move up (respecting display lines)", expr = true },
	['j'] = { "v:count == 0 ? 'gj' : 'j'", "Move down (respecting display lines)", expr = true },
	['<C-_>'] = { ":lua require('Comment.api').toggle_current_linewise()<CR>", "Toggle comment for current line", mode = { "n", "v" } },
	['<Esc>'] = { "<ESC>:noh<CR>:require('notify').dismiss()<CR>", "Clear search highlight and notifications" },
	['nl'] = { refresh_lualine, "Refresh status line" },
}

-- LSP Keymaps
local lspMappings = {
	['rn'] = { vim.lsp.buf.rename, "Rename" },
	['ca'] = { vim.lsp.buf.code_action, "Code Action" },
	['gd'] = { require('telescope.builtin').lsp_definitions, "Goto Definition" },
	['gr'] = { require('telescope.builtin').lsp_references, "Goto References" },
	['gI'] = { require('telescope.builtin').lsp_implementations, "Goto Implementations" },
	['D'] = { require('telescope.builtin').lsp_type_definitions, "Type Definition" },
	['ds'] = { require('telescope.builtin').lsp_document_symbols, "Document Symbols" },
	['ws'] = { require('telescope.builtin').lsp_workspace_symbols, "Workspace Symbols" },
	['K'] = { vim.lsp.buf.hover, "Hover Documentation" },
	['C-k>'] = { vim.lsp.buf.signature_help, "Signature Help" },
	['gD'] = { vim.lsp.buf.declaration, "Goto Declaration" },
	['wa'] = { vim.lsp.buf.add_workspace_folder, "Add Workspace Folder" },
	['wr'] = { vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder" },
	['wl'] = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List Workspace Folders" },
	['Q'] = { vim.diagnostic.setloclist, "Open Diagnostics List" },
	[']d'] = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
	['[d'] = { vim.diagnostic.goto_next, "Next Diagnostic" },
	['fm'] = { function() vim.lsp.buf.format { async = true } end, "Format Document" },
}

-- Telescope Keymaps
local telescopeMappings = {
	['tf'] = { require('telescope.builtin').git_files, "Search Git Files" },
	['tS'] = { require('telescope.builtin').find_files, "Search Files" },
	['th'] = { require('telescope.builtin').help_tags, "Search Help" },
	['tw'] = { require('telescope.builtin').grep_string, "Search Current Word" },
	['tg'] = { require('telescope.builtin').live_grep, "Search by Grep" },
	['tG'] = { "<cmd>Telescope live_grep search_dirs={'$(git rev-parse --show-toplevel)'}<CR>", "Grep in Git Directory" },
	['td'] = { require('telescope.builtin').diagnostics, "Search Diagnostics" },
	['tr'] = { require('telescope.builtin').resume, "Resume Last Search" },
	['tc'] = { require('telescope.builtin').commands, "Search Telescope Commands" },
	['tC'] = { require('telescope.builtin').command_history, "Search Command History" },
	['tH'] = { require('telescope.builtin').search_history, "Search History" },
	['tM'] = { require('telescope.builtin').man_pages, "Search Man Pages" },
	['tm'] = { require('telescope.builtin').keymaps, "Search Keymaps" },
	['ts'] = { require('telescope.builtin').spell_suggest, "Search Spelling Suggestions" },
	['ta'] = { "<cmd>Telescope dash search<CR>", "Search Dash" },
	['tt'] = { "<cmd>Telescope themes<CR>", "Search Themes" },
	['te'] = { "<cmd>Telescope emoji<CR>", "Search Emojis" },
	['?'] = { require('telescope.builtin').oldfiles, "[?] Find recently opened files" },
	['<space>'] = { require('telescope.builtin').buffers, "[ ] Find existing buffers" },
	["/"] = { require('telescope.builtin').current_buffer_fuzzy_find, "[/] Fuzzily search in current buffer" },
}

-- Rnvimr and Ranger Keymaps
local rnvimrMappings = {
	['rt'] = { ":RnvimrToggle<CR>", "Toggle Rnvimr" },
	['rr'] = { ":RnvimrResize<CR>", "Resize Rnvimr" },
	['rf'] = { function() require("ranger-nvim").open(true) end, "Open Ranger" },
}

-- legendary.nvim Keymaps
local legendaryMappings = {
	['lg'] = { ":Legendary<CR>", "Search Legendary" },
	['lk'] = { ":Legendary keymaps<CR>", "Search Legendary Keymaps" },
	['lc'] = { ":Legendary commands<CR>", "Search Legendary Commands" },
	['lf'] = { ":Legendary functions<CR>", "Search Legendary Functions" },
	['la'] = { ":Legendary autocmds<CR>", "Search Legendary Autocmds" },
	['lr'] = { ":LegendaryRepeat<CR>", "Repeat Last Item Executed" },
	['l!'] = { ":LegendaryRepeat!<CR>", "Repeat Last Item Executed, no filters" },
}

-- Tmux Telescope Plugin Keymaps
local tmuxTelescopeMappings = {
	["ft"] = { ":TmuxJumpFile<CR>", "Jump to File in Tmux Pane" },
	[";"]  = { ":TmuxJumpFirst<CR>", "Jump to First Tmux Pane" },
}

-- Harpoon Keymaps
local harpoonMappings = {
	["ha"] = { function() harpoon:list():append() end, "Add File to Harpoon Menu" },
	["hr"] = { function() harpoon:list():remove() end, "Remove File from Harpoon Menu" },
	["hp"] = { function() harpoon.nav.prev() end, "Previous Harpoon File" },
	["hn"] = { function() harpoon.nav.next() end, "Next Harpoon File" },
	["hm"] = { function() harpoon.ui.toggle_quick_menu() end, "Harpoon Quick Menu" },
}

-- Obsidian Keymaps
local obsidianMappings = {
	["on"] = { function() return require("obsidian").util.gf_passthrough() end, "Go to Note Under Cursor", opts = { noremap = false, expr = true, buffer = true } },
	["oc"] = { function() return require("obsidian").util.toggle_checkbox() end, "Toggle Checkboxes", opts = { buffer = true } },
}

-- Lazy Keymaps
local lazyMappings = {
	["lz"] = { ":Lazy<CR>", "Open Lazy" },
	["lr"] = { ":LazyRoot<CR>", "Open LazyRoot" },
	["le"] = { ":LazyExtras<CR>", "Open LazyExtras" },
	["lf"] = { ":LazyFormat<CR>", "Open LazyFormat" },
	["lh"] = { ":LazyHealth<CR>", "Open LazyHealth" },
	["li"] = { ":LazyFormatInfo<CR>", "Open LazyFormatInfo" },
}


-- DAP Plugin Keymaps
local dapMappings = {
	["<F5>"] = { dap.continue, "Debug: Start/Continue" },
	["<F1>"] = { dap.step_into, "Debug: Step Into" },
	["<F2>"] = { dap.step_over, "Debug: Step Over" },
	["<F3>"] = { dap.step_out, "Debug: Step Out" },
	["db"] = { dap.toggle_breakpoint, "Debug: Toggle Breakpoint" },
	["dB"] = { function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, "Debug: Set Breakpoint" },
	["<F7>"] = { dapui.toggle, "Debug: See last session result." },
}

-- Setup with default options
wk.setup {}

-- Registering mappings
wk.register(generalMappings, { prefix = "<leader>", mode = "n" })
wk.register(lspMappings, { prefix = "<leader>", mode = "n" })
-- Registering Telescope mappings under the 'n' (normal) mode leader key
wk.register(telescopeMappings, { prefix = "<leader>", mode = "n" })

-- Registering Rnvimr mappings
wk.register(rnvimrMappings, { prefix = "<leader>", mode = "n" })

-- Registering legendary.nvim mappings
wk.register(legendaryMappings, { prefix = "<leader>", mode = "n" })

-- Registering Tmux Telescope mappings under the 'n' (normal) mode leader key
wk.register(tmuxTelescopeMappings, { prefix = "<leader>", mode = "n" })

-- Registering DAP mappings under the 'n' (normal) mode leader key
-- Note: F-keys are registered globally, not under a leader key.
wk.register(dapMappings, { mode = "n" })

-- For F-keys which are not under the leader key, you can register them separately
wk.register({
	["<F1>"] = { dap.step_into, "Debug: Step Into" },
	["<F2>"] = { dap.step_over, "Debug: Step Over" },
	["<F3>"] = { dap.step_out, "Debug: Step Out" },
	["<F5>"] = { dap.continue, "Debug: Start/Continue" },
	["<F7>"] = { dapui.toggle, "Debug: See last session result." },
}, { mode = "n", prefix = "" })

-- Registering Harpoon mappings under the 'n' (normal) mode leader key
wk.register(harpoonMappings, { prefix = "<leader>", mode = "n" })

-- Registering numeric mappings for selecting Harpoon files
for i = 1, 9 do
	wk.register({
		[tostring(i)] = { function() harpoon.ui.nav_file(i) end, "Harpoon to File " .. i }
	}, { prefix = "<leader>", mode = "n" })
end

-- Registering Obsidian mappings under the 'n' (normal) mode leader key
wk.register(obsidianMappings, { prefix = "<leader>", mode = "n" })

-- Registering Lazy mappings under the 'n' (normal) mode leader key
wk.register(lazyMappings, { prefix = "<leader>", mode = "n" })
