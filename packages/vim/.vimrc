" VIM-PLUG {{{
call plug#begin()
	Plug 'tpope/vim-sensible' " Smart defaults

    " Linting, Formatting
    Plug 'dense-analysis/ale'

    " Navigation
    Plug 'airblade/vim-rooter'          " Autoset project root
    Plug 'kana/vim-textobj-user'        " Custom text objects
    Plug 'ludovicchabant/vim-gutentags' " CTags frontend
    Plug 'preservim/tagbar'             " Way to see all tags in a file

    " Git
	Plug 'tpope/vim-fugitive'     " Git integration
    Plug 'airblade/vim-gitgutter' " Show hunks in a gutter

    " Editing
    Plug 'junegunn/vim-easy-align' " Alignment
    Plug 'tpope/vim-commentary'    " Better comment management
    Plug 'tpope/vim-repeat'        " Make <.> work on plugins, too
    Plug 'tpope/vim-surround'      " Surround management

    " Filetype Specific
    Plug 'lervag/vimtex'     " Various LaTeX things
    Plug 'vim-scripts/a.vim' " Switch between %.c and %.h quickly

    " Snippets
    Plug 'honza/vim-snippets' " General provider
	Plug 'SirVer/ultisnips'   " Engine

    " LSP Integration
    Plug 'prabirshrestha/vim-lsp' " LSP frontend
    Plug 'mattn/vim-lsp-settings' " Automatically manage LSPs for files

    " Autocomplete Menu
    Plug 'prabirshrestha/asyncomplete.vim'           " Main plugin
    Plug 'prabirshrestha/asyncomplete-ultisnips.vim' " UltiSnips integration
    Plug 'prabirshrestha/asyncomplete-lsp.vim'       " vim-lsp integration

    " Theme
	Plug 'morhetz/gruvbox'
call plug#end()
" }}} VIM-PLUG
" ALE {{{
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'cpp': ['clang-format', 'clangtidy'],
\   'c': ['clang-format', 'clangtidy'],
\   'python': ['black', 'isort'],
\   'tex': ['latexindent']
\}

let g:ale_fix_on_save = 1

let g:ale_linters = {
\   'c': ['cc'],
\   'cpp': ['cc'],
\   'python': ['ruff'],
\   'javascript': ['eslint'],
\   'tex': ['chktex']
\}
let g:ale_completion_autoimport = 1

" Quickfix list integration
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
" }}} ALE
" VimTeX {{{
let g:vimtex_view_method='zathura'
let g:vimtex_compiler_method='latexmk'

let g:tex_flavor='latex'
" }}} VimTeX
" VIM-LSP {{{
" Python
if executable('pyright')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyright',
        \ 'cmd': {server_info->['pyright']},
        \ 'allowlist': ['python'],
        \ })
endif
" C, C++, Objective C, Objective C++
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif
" Typescript, Javascript
if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript', 'typescript.tsx', 'typescriptreact'],
        \ })
    au User lsp_setup call lsp#register_server({
      \ 'name': 'javascript support using typescript-language-server',
      \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
      \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
      \ 'whitelist': ['javascript', 'javascript.jsx', 'javascriptreact']
      \ })
endif
" }}} VIM-LSP
" ASYNCOMPLETE {{{
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1

call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
    \ 'name': 'ultisnips',
    \ 'allowlist': ['*'],
    \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
    \ }))
" }}} ASYNCOMPLETE
" ULTISNIPS {{{
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" }}} ULTISNIPS
" AUGROUPS {{{
augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction
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
" }}} BINDS
" COMMANDS {{{
command! E Explore
" Diff helper
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif
" }}} COMMANDS
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

set completeopt=menuone,noinsert,noselect
" }}} CONFIG
" APPEARANCE {{{
set termguicolors
set background=dark
set cursorline
colorscheme gruvbox
filetype plugin indent on
syntax on
" }}} APPEARANCE
