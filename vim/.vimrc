" Basic Vimrc


set nocompatible


" Show line numbers
set number
" Show statusline
set laststatus=2

" Case-insensitive search
set ignorecase

" Highlight search results
set hlsearch

" Default to soft tabs, 4 spaces
set expandtab
set sw=4
set sts=4
" Except for Makefiles: Hard tabs of width 2
" More exceptions may be found in editorconfig/.editorconfig
autocmd FileType make set ts=2
autocmd FileType python set breakindentopt=shift:4


" Do not attempt to fix style on paste
" Normally we would just `set paste`, but this interferes with other aliases.
nnoremap <silent> p "+p

" Disable comment continuation on paste
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o


" Default to Unix LF line endings
set ffs=unix


" Folding
set foldmethod=syntax
set foldcolumn=1
set foldlevelstart=20

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    " let Vundle manage Vundle, required
    Plugin 'VundleVim/Vundle.vim'

    Plugin 'bling/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'elzr/vim-json'
    Plugin 'godlygeek/tabular'
    Plugin 'plasticboy/vim-markdown'
    Plugin 'mtth/scratch.vim'
    Plugin 'fsouza/go.vim'
    Plugin 'wting/rust.vim'
    Plugin 'tpope/vim-fugitive'
    Plugin 'editorconfig/editorconfig-vim'
    Plugin 'mcandre/Conque-Shell'
    Plugin 'mattn/emmet-vim'
    Plugin 'christoomey/vim-tmux-navigator'
    Plugin 'scrooloose/syntastic'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"
syntax on

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1

" Enable Powerline fonts for airline
let g:airline_powerline_fonts = 1
let g:airline_theme='distinguished'

" Scratch splits the current window in half
let g:scratch_height = 0.50
" Scratch opens in Markdown format
let g:scratch_filetype = 'markdown'
"let g:scratch_persistence_file = '.vim_scratch'

" Emnet
" Default: Then type <c-y>, (Ctrly,) after typing zen stuff
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall


"======Solarized theme============
syntax on
syntax enable
let g:solarized_termtrans = 1
set background=dark
"set t_Co=256
let g:solarized_termcolors=256
colorscheme solarized


" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
