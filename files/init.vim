set rnu nu nocompatible autoindent smartindent hlsearch incsearch visualbell
set tabstop=4 softtabstop=4 shiftwidth=4
set mouse=a
nmap <F8> :TagbarToggle<CR>

" Function to set tab width to n spaces
function! SetTab(n)
	let &l:tabstop=a:n
	let &l:softtabstop=a:n
	let &l:shiftwidth=a:n
endfunction

command! -nargs=1 SetTab call SetTab(<f-args>)
command! FixTab :%s/    /\t/g


call plug#begin('~/.local/share/nvim/plugged')

"	Plug 'davidhalter/jedi-vim'                                   " Autocomplete
"	Plug 'sheerun/vim-polyglot'                                   " Autocomplete
"	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " Autocomplete
"	Plug 'zchee/deoplete-jedi'                                    " Autocomplete
"	Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }       " Autocomplete
	Plug 'rust-lang/rust.vim'                                     " Rust, just in case

	Plug 'vim-python/python-syntax'								  " Python syntax
	Plug 'Vimjas/vim-python-pep8-indent'						  " Python indentation
"	Plug 'jeetsukumaran/vim-pythonsense'						  " Pythonsense

	Plug 'SirVer/ultisnips'										  " Snippets
	Plug 'jalvesaq/vimcmdline'									  " Interpareter to REPL
	Plug 'petRUShka/vim-sage'									  " Sagemath
	Plug 'vim-airline/vim-airline'                                " bottom line
	Plug 'vim-airline/vim-airline-themes'                         " bottom line theme
"	Plug 'jiangmiao/auto-pairs'                                    Complete pairs
	Plug 'scrooloose/nerdtree'                                    " NERDtree
	Plug 'joshdick/onedark.vim'                                   " Darktheme
	Plug 'tommcdo/vim-lion'                                       " Align at characters    gl/gL
	Plug 'tpope/vim-surround'                                     " change cs({     remove  ds'         wrap yss(
	Plug 'luochen1990/rainbow'                                    " Rainbow parenthethies
	Plug 'preservim/tagbar'                                       " Keeps track of scope


call plug#end()

let g:deoplete#enable_at_startup  = 1
let g:jedi#completions_enabled    = 1
let g:jedi#use_splits_not_buffers = "right"

let maplocalleader    = "\<bs>"
let mapleader         = "\<space>"
let cmdline_map_send = '<Enter>'

nnoremap <leader>d dd

inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

if (empty($TMUX))
	if (has("nvim"))
		let $NVIM_TUI_ENABLE_TRUE_COLOR=1
	endif
	if (has("termguicolors"))
	"  set termguicolors
	endif
endif

if (has("autocmd") && !has("gui_running"))
	augroup colorset
	autocmd!
	let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
	autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
	augroup END
endif

syntax on

let g:airline#extensions#tabline#enabled      = 1
let g:airline#extensions#tabline#left_sep     = ''
let g:airline#extensions#tabline#left_alt_sep = ''

colorscheme onedark
let g:airline_theme = 'onedark'

set noshowmode
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
" unicode symbols
let g:airline_symbols.linenr     = '☰'
let g:airline_symbols.paste      = 'ρ'
let g:airline_symbols.paste      = 'Þ'
let g:airline_symbols.notexists  = '∄'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep          = ''
let g:airline_left_alt_sep      = ''
let g:airline_right_sep         = ''
let g:airline_right_alt_sep     = ''
let g:airline_symbols.branch    = ''
let g:airline_symbols.readonly  = ''
let g:airline_symbols.linenr    = '☰'
let g:airline_symbols.maxlinenr = ''


