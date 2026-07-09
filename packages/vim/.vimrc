" VIM-PLUG {{{
call plug#begin()
	Plug 'tpope/vim-fugitive'              " Git
	Plug 'tpope/vim-sensible'              " Smart defaults
	Plug 'SirVer/ultisnips'                " Snippet engine
    Plug 'honza/vim-snippets'              " Snippets
	Plug 'morhetz/gruvbox'                 " Theme
    Plug 'dense-analysis/ale'              " ALE
    Plug 'vim-scripts/a.vim'               " Switch between %.c and %.h quickly
    Plug 'ludovicchabant/vim-gutentags'    " CTags frontend
    Plug 'lervag/vimtex'                   " LaTeX
    Plug 'tpope/vim-commentary'            " Better comment management
    Plug 'kana/vim-textobj-user'           " Custom text objects
    Plug 'junegunn/vim-easy-align'         " Alignment
    Plug 'tpope/vim-surround'              " Surround management
    Plug 'tpope/vim-repeat'                " Make <.> work on plugins, too
    Plug 'preservim/tagbar'                " Way to see all tags in a file
    Plug 'airblade/vim-rooter'             " Autoset project root
    Plug 'prabirshrestha/asyncomplete.vim' " Autocomplete menu
call plug#end()
" }}}
" ALE {{{
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'cpp': ['clang-format'],
\   'c': ['clang-format'],
\   'python': ['black'],
\   'tex': ['latexindent']
\}

let g:ale_fix_on_save = 1

let g:ale_linters = {
\   'c': ['clangd'],
\   'cpp': ['clangd'],
\   'python': ['flake8'],
\   'javascript': ['eslint'],
\   'tex': ['chktex']
\}
let g:ale_completion_autoimport = 1

" Quickfix list integration
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
" }}}
" VimTeX {{{
let g:vimtex_view_method='zathura'
let g:vimtex_compiler_method='latexmk'

let g:tex_flavor='latex'
" }}} VimTeX
" ULTISNIPS {{{

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" }}}
" AUGROUPS {{{
augroup AleProvidesCompetion
    autocmd!
    autocmd FileType c,cpp,javascript,typescript,python setlocal omnifunc=ale#completion#OmniFunc
augroup END
" }}} AUGROUPS
" BINDS {{{
map Q gq

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

nnoremap <silent>gd :ALEGoToDefinition<CR>

nnoremap <leader>td :TagbarToggle<CR>
nnoremap <leader>tt :GutentagsUpdate<CR>

nnoremap <C-]> <cmd>tab split<CR><cmd>tag <C-r><C-w><CR>

nnoremap <leader>f :grep
nnoremap <leader>w :vimgrep /\<<C-r><C-w>\>/gj **/*<CR>

" <l>a switches .c <-> .h
" <l>o opens .h [or .c if in .h] in a split
nnoremap <leader>a :A<CR>
nnoremap <leader>o :AS<CR>

nnoremap <leader>q :copen<CR>
nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>

inoremap <expr> <C-b> pumvisible() ? "\<C-n>" : "\<C-R>=UltiSnips#JumpForwards()<CR>"
inoremap <expr> <C-x> pumvisible() ? "\<C-p>" : "\<C-R>=UltiSnips#JumpBackwards()<CR>"
" }}}
" COMMANDS {{{
command! E Explore
" Diff helper
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif
" }}}
" CONFIG {{{
set number
set relativenumber
set nocompatible
set ttimeout          " time out for key codes
set ttimeoutlen=100   " wait up to 100ms after Esc for special key
set scrolloff=5
set textwidth=80

set incsearch
set hlsearch
set ignorecase
set smartcase

set smarttab
set expandtab
set softtabstop=4
set shiftwidth=4
set tabstop=4

if has('persistent_undo')
set undofile
set undodir=~/.vim/undo
endif

set updatetime=1000
set signcolumn=yes

set foldmethod=marker

set grepprg=rg\ --vimgrep

set hidden
set mouse=a

set splitbelow
set splitright

set wildmenu
set wildmode=longest:full,full

set showcmd
set showmode

set nowrap

set shortmess+=c
set belloff+=ctrlg
" }}}
" APPEARANCE {{{
set termguicolors
set background=dark
set cursorline
colorscheme gruvbox
filetype plugin indent on
syntax on
" }}}
