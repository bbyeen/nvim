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

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  if packer_bootstrap then
    require('packer').sync()
  end

vim.cmd([[
"windows auto resize as equal size
autocmd VimResized * wincmd =

"o on line with comment won't generate a commented line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
colorscheme gruvbox
set termguicolors
set softtabstop=4
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set ignorecase
set smartcase
set termguicolors
set expandtab
set encoding=utf8
set foldmethod=indent
set foldnestmax=1
set foldlevel=1
set nofoldenable
set number
set showcmd
set wildmenu
set incsearch
set hlsearch
set laststatus=2 "always display statusline
set splitright
set mouse=a "adds mouse click
set noshowmode
set ttimeoutlen=100
set encoding=UTF-8
set cursorline
set showbreak=↪\-
set list
set relativenumber
set nopaste
set inccommand=nosplit
set showtabline=2
autocmd TermOpen * setlocal nonumber norelativenumber
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_echo_msg_error_str = '❌'
let g:ale_echo_msg_warning_str = '⚠️'
let g:ale_echo_msg_format = '[%linter%] %s %severity%'
let g:ale_disable_lsp = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
" You can disable this option too
" if you don't want linters to run on opening a file

let g:ale_lint_on_enter = 0
let g:cpp_attributes_highlight = 1
let g:cpp_member_highlight = 1
let g:cpp_simple_highlight = 1
let g:DevIconsEnableFoldersOpenClose=1
let g:asyncrun_open = 6
let g:asynctasks_term_pos = 'right'
let g:rainbow_active = 1
let mapleader = "ò"
nnoremap <leader><space> :nohlsearch<CR>

"open 10 line terminal below
nnoremap <leader>o :vertical sp term://$SHELL<cr>i

"adds space above
nnoremap <leader>su O<Esc>j

"indent all block
nnoremap <leader>ib =i{

"intend all file
nnoremap <leader>ia gg=G-

"replace word under cursor with word to insert
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"==========MAP=====================

"Disable ex mode-
nnoremap Q <Nop>

nnoremap SD :cd %:p:h<CR>
"sw stands for surround word and sl stands for surround line. Short commands for surround plugin.
"Type what you want after to sorround word/line
map sw ysiw
map sl yss

"remap save on ctrl+s
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>
nnoremap <C-q> :q<CR>
inoremap <C-q> <Esc>:q<CR>

"trying to learn those fucking hjkl
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
"colemak
""noremap n h
""noremap e j
""noremap i k
""noremap o l

" remove c-z
noremap <C-z> <Nop>

"newtab
nnoremap <C-t> :tabnew<CR>

"move between tabs
nnoremap <C-n> :tabNext<CR>

"allow esc on terminal window
tnoremap <Esc> <C-\><C-n>
tnoremap <C-q> <C-\><C-n>:q<CR>

"move easily between splits
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

"Paste on line below the cursor
nnoremap ,p :pu<CR>

"zi (zoom-in) and zo (zoom-out)
nnoremap zi <C-w><Bar><C-w>_<cr>
nnoremap zo <C-w>=

"=======CUSTOM COMMANDS=======
"replaces all the occurences of src with dest (only exact match)
function! FindAndReplaceExact(src,dest)
    execute ':%s/\<' . a:src . '\>/' . a:dest . '/gc'
endfunction

command -nargs=* Fre call FindAndReplaceExact(<f-args>)

function! FindAndReplace(src,dest)
    execute ':%s/' . a:src . '/' . a:dest . '/gc'
endfunction

command -nargs=* Frs call FindAndReplace(<f-args>)

command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
" tree
noremap <C-f> :NvimTreeToggle<CR>
noremap <silent><S-X> :AsyncTask file-run<cr>
noremap <silent><S-Z> :AsyncTask file-build<cr>
" colorizer
noremap <silent><S-C> :ColorizerToggle<cr>
" whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
au BufWinEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
au BufWinLeave * call clearmatches()
]])


local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

local lsp = require('lsp-zero').preset({
  float_border = 'rounded',
  call_servers = 'local',
  configure_diagnostics = true,
  setup_servers_on_start = true,
  set_lsp_keymaps = {
    preserve_mappings = false,
    omit = {},
  },
  manage_nvim_cmp = {
    set_sources = 'recommended',
    set_basic_mappings = true,
    set_extra_mappings = false,
    use_luasnip = true,
    set_format = true,
    documentation_window = true,
  },
})

  lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.set_sign_icons({
  error = '❌',
  warn = '⚠️',
  hint = '🚩',
  info = '➡️'
})


-- When you don't have mason.nvim installed
-- You'll need to list the servers installed in your system
lsp.setup_servers({'tsserver', 'eslint', 'clangd', 'rust_analyzer', 'pylsp'})
lsp.ensure_installed({
  'html',
  'cssls',
  'tsserver',
  'clangd',
  'rust_analyzer'
})

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.setup()

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = {  "rust", "cpp", "c", "vim", "help", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = true,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,
  autotag = {

  enable = true,

  },
  indent = {
  enable = true,
  },
  rainbow = {
  enable = true,
  extended_mode = true,
  },

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {  },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

vim.opt.termguicolors = true
require("bufferline").setup{}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    component_separators = '|',
    section_separators = '',
    -- component_separators = { left = '', right = ''},
    -- section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
     symbols = { error = '❌ ', warn = '⚠️ ', info = 'ℹ️ ', hint = '💡 ' },
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

require 'colorizer'.setup {
  '*'; -- Highlight all files, but customize some others.
}

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'morhetz/gruvbox'
  use 'sheerun/vim-polyglot'
  use 'scrooloose/NERDTree'
  use 'jiangmiao/auto-pairs'
  use 'bfrg/vim-cpp-modern'
  use 'dense-analysis/ale'
  use 'luochen1990/rainbow'
  use 'skywind3000/asynctasks.vim'
  use 'skywind3000/asyncrun.vim'
  use 'rktjmp/lush.nvim'
  use 'tyru/caw.vim'
  use 'nvim-lualine/lualine.nvim'
  use 'norcalli/nvim-colorizer.lua'
  use 'nvim-tree/nvim-tree.lua'
  use 'simrat39/rust-tools.nvim'
  use 'rust-lang/rust.vim'
  use 'saecki/crates.nvim'
  use 'nvim-lua/plenary.nvim'

local M = {}

function M.length(table)
    local count = 0
    for _, _ in ipairs(table) do
        count = count + 1
    end
    return count
end

M.border_chars_none = { "", "", "", "", "", "", "", "" }
M.border_chars_empty = { " ", " ", " ", " ", " ", " ", " ", " " }

M.border_chars_inner_thick = { " ", "▄", " ", "▌", " ", "▀", " ", "▐" }
M.border_chars_outer_thick = { "▛", "▀", "▜", "▐", "▟", "▄", "▙", "▌" }

M.border_chars_outer_thin = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }
M.border_chars_inner_thin = { " ", "▁", " ", "▏", " ", "▔", " ", "▕" }

M.top_right_corner_thin = "🭾"
M.top_left_corner_thin = "🭽"

M.border_chars_outer_thin_telescope = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" }
M.border_chars_outer_thick_telescope = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" }

local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}
-- Setup cmp
local cmp = require("cmp")
cmp.setup({
    view = {
  entries = {name = 'custom', selection_order = 'near_cursor' }
},
      window = {
        completion = {
border_chars_none = { "", "", "", "", "", "", "", "" },
border = { " ", " ", " ", " ", " ", " ", " ", " " },
      },
        documentation = {
          border = { " ", " ", " ", " ", " ", " ", " ", " " },
        },
      },
    formatting = {
      format = function(entry, vim_item)
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[LaTeX]",
      })[entry.source.name]
      return vim_item
    end
  },
	mapping = cmp.mapping.preset.insert({ -- Preset: ^n, ^p, ^y, ^e, you know the drill..
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
	}),
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "nvim_lua" },
		{ name = "luasnip" },
        { name = "crates" },
		{ name = "path" },
	}, {
		{ name = "buffer", keyword_length = 3 },
	}),
})

-- Setup buffer-local keymaps / options for LSP buffers
local lsp_attach = function(client, buf)
	-- Example maps, set your own with vim.api.nvim_buf_set_keymap(buf, "n", <lhs>, <rhs>, { desc = <desc> })
	-- or a plugin like which-key.nvim
	-- <lhs>        <rhs>                        <desc>
	-- "K"          vim.lsp.buf.hover            "Hover Info"
	-- "<leader>qf" vim.diagnostic.setqflist     "Quickfix Diagnostics"
	-- "[d"         vim.diagnostic.goto_prev     "Previous Diagnostic"
	-- "]d"         vim.diagnostic.goto_next     "Next Diagnostic"
	-- "<leader>e"  vim.diagnostic.open_float    "Explain Diagnostic"
	-- "<leader>ca" vim.lsp.buf.code_action      "Code Action"
	-- "<leader>cr" vim.lsp.buf.rename           "Rename Symbol"
	-- "<leader>fs" vim.lsp.buf.document_symbol  "Document Symbols"
	-- "<leader>fS" vim.lsp.buf.workspace_symbol "Workspace Symbols"
	-- "<leader>gq" vim.lsp.buf.formatting_sync  "Format File"

	vim.api.nvim_buf_set_option(buf, "formatexpr", "v:lua.vim.lsp.formatexpr()")
	vim.api.nvim_buf_set_option(buf, "omnifunc", "v:lua.vim.lsp.omnifunc")
	vim.api.nvim_buf_set_option(buf, "tagfunc", "v:lua.vim.lsp.tagfunc")
end

-- Setup rust_analyzer via rust-tools.nvim
require("rust-tools").setup({
	server = {
		capabilities = capabilities,
		on_attach = lsp_attach,
	}
})
require('rust-tools').inlay_hints.set()
require('rust-tools').inlay_hints.enable()
require('rust-tools').hover_actions.hover_actions()
require('crates').setup {
    smart_insert = true,
    insert_closing_quote = true,
    avoid_prerelease = true,
    autoload = true,
    autoupdate = true,
    autoupdate_throttle = 250,
    loading_indicator = true,
    date_format = "%Y-%m-%d",
    thousands_separator = ".",
    notification_title = "Crates",
    curl_args = { "-sL", "--retry", "1" },
    max_parallel_requests = 80,
    open_programs = { "xdg-open", "open" },
    disable_invalid_feature_diagnostic = false,
    text = {
        loading = "   Loading",
        version = "   %s",
        prerelease = "   %s",
        yanked = "   %s",
        nomatch = "   No match",
        upgrade = "   %s",
        error = "   Error fetching crate",
    },
    highlight = {
        loading = "CratesNvimLoading",
        version = "CratesNvimVersion",
        prerelease = "CratesNvimPreRelease",
        yanked = "CratesNvimYanked",
        nomatch = "CratesNvimNoMatch",
        upgrade = "CratesNvimUpgrade",
        error = "CratesNvimError",
    },
    popup = {
        autofocus = false,
        hide_on_select = false,
        copy_register = '"',
        style = "minimal",
        border = "none",
        show_version_date = false,
        show_dependency_version = true,
        max_height = 30,
        min_width = 20,
        padding = 1,
        text = {
            title = " %s",
            pill_left = "",
            pill_right = "",
            description = "%s",
            created_label = " created        ",
            created = "%s",
            updated_label = " updated        ",
            updated = "%s",
            downloads_label = " downloads      ",
            downloads = "%s",
            homepage_label = " homepage       ",
            homepage = "%s",
            repository_label = " repository     ",
            repository = "%s",
            documentation_label = " documentation  ",
            documentation = "%s",
            crates_io_label = " crates.io      ",
            crates_io = "%s",
            categories_label = " categories     ",
            keywords_label = " keywords       ",
            version = "  %s",
            prerelease = " %s",
            yanked = " %s",
            version_date = "  %s",
            feature = "  %s",
            enabled = " %s",
            transitive = " %s",
            normal_dependencies_title = " Dependencies",
            build_dependencies_title = " Build dependencies",
            dev_dependencies_title = " Dev dependencies",
            dependency = "  %s",
            optional = " %s",
            dependency_version = "  %s",
            loading = "  ",
        },
        highlight = {
            title = "CratesNvimPopupTitle",
            pill_text = "CratesNvimPopupPillText",
            pill_border = "CratesNvimPopupPillBorder",
            description = "CratesNvimPopupDescription",
            created_label = "CratesNvimPopupLabel",
            created = "CratesNvimPopupValue",
            updated_label = "CratesNvimPopupLabel",
            updated = "CratesNvimPopupValue",
            downloads_label = "CratesNvimPopupLabel",
            downloads = "CratesNvimPopupValue",
            homepage_label = "CratesNvimPopupLabel",
            homepage = "CratesNvimPopupUrl",
            repository_label = "CratesNvimPopupLabel",
            repository = "CratesNvimPopupUrl",
            documentation_label = "CratesNvimPopupLabel",
            documentation = "CratesNvimPopupUrl",
            crates_io_label = "CratesNvimPopupLabel",
            crates_io = "CratesNvimPopupUrl",
            categories_label = "CratesNvimPopupLabel",
            keywords_label = "CratesNvimPopupLabel",
            version = "CratesNvimPopupVersion",
            prerelease = "CratesNvimPopupPreRelease",
            yanked = "CratesNvimPopupYanked",
            version_date = "CratesNvimPopupVersionDate",
            feature = "CratesNvimPopupFeature",
            enabled = "CratesNvimPopupEnabled",
            transitive = "CratesNvimPopupTransitive",
            normal_dependencies_title = "CratesNvimPopupNormalDependenciesTitle",
            build_dependencies_title = "CratesNvimPopupBuildDependenciesTitle",
            dev_dependencies_title = "CratesNvimPopupDevDependenciesTitle",
            dependency = "CratesNvimPopupDependency",
            optional = "CratesNvimPopupOptional",
            dependency_version = "CratesNvimPopupDependencyVersion",
            loading = "CratesNvimPopupLoading",
        },
        keys = {
            hide = { "q", "<esc>" },
            open_url = { "<cr>" },
            select = { "<cr>" },
            select_alt = { "s" },
            toggle_feature = { "<cr>" },
            copy_value = { "yy" },
            goto_item = { "gd", "K", "<C-LeftMouse>" },
            jump_forward = { "<c-i>" },
            jump_back = { "<c-o>", "<C-RightMouse>" },
        },
    },
    src = {
        insert_closing_quote = true,
        text = {
            prerelease = "  pre-release ",
            yanked = "  yanked ",
        },
        coq = {
            enabled = false,
            name = "Crates",
        },
    },
    null_ls = {
        enabled = false,
        name = "Crates",
    },
    on_attach = function(bufnr) end,
}

  use 'mfussenegger/nvim-dap'

      use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}

      use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
      use {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v1.x',
  requires = {
    -- LSP Support
    {'neovim/nvim-lspconfig'},             -- Required

    -- Autocompletion
    {'hrsh7th/nvim-cmp'},         -- Required
    {'hrsh7th/cmp-nvim-lsp'},     -- Required
    {'hrsh7th/cmp-buffer'},       -- Optional
    {'hrsh7th/cmp-path'},         -- Optional
    {'saadparwaiz1/cmp_luasnip'}, -- Optional
    {'hrsh7th/cmp-nvim-lua'},     -- Optional

    -- Snippets
    {'L3MON4D3/LuaSnip'},             -- Required
    {'rafamadriz/friendly-snippets'}, -- Optional
  }
}
end)

end)
