" Basic Vimrc


set nocompatible   " Don't behave like vi

filetype off " when file types are on before plugins are loaded stuff happens

set encoding=utf-8 " UTF-8 is my default text encoding.
set scrolloff=5    " scroll within n lines ow window edge
" Show line numbers
set number
" Show statusline
set laststatus=2

" search
" set ignorecase " Case-insensitive search
set smartcase " uppercase matches uppercase, lowercase matches any case
set incsearch " search while typing
set hlsearch " Highlight search results
set showmatch " briefly jump to matching bracket pairs, if they are visible.

set backspace=indent,eol,start

" Default to soft tabs, 4 spaces
set expandtab
set sw=4
set sts=4
" Except for Makefiles: Hard tabs of width 2
" More exceptions may be found in editorconfig/.editorconfig
autocmd FileType make set ts=2
autocmd FileType python set breakindentopt=shift:4

au BufRead,BufNewFile tmpmsg.* set filetype=mail
au BufRead,BufNewFile *.pde set filetype=arduino
au BufRead,BufNewFile *.ino set filetype=arduino

" system wide copy-paste with ctrl-c ctrl-v
vmap <c-c> "+y
nmap <c-v> "+p

" Disable comment continuation on paste
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o


" Default to Unix LF line endings
set ffs=unix

imap <C-d> <Esc> " leave insert mode with ctrl-d

" I always accidently hit :W instread of :w, so make both work
command! W write

" Show trailing whitepace and spaces before a tab:
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL

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

    Plugin 'fsouza/go.vim'
    Plugin 'wting/rust.vim'
    Plugin 'elzr/vim-json'
    Plugin 'PotatoesMaster/i3-vim-syntax'
    Plugin 'plasticboy/vim-markdown'
    Plugin 'ap/vim-css-color'
    Plugin 'pearofducks/ansible-vim'

    Plugin 'neomake/neomake'
    Plugin 'godlygeek/tabular'
    Plugin 'mtth/scratch.vim'

    Plugin 'tpope/vim-fugitive'
    Plugin 'editorconfig/editorconfig-vim'
    Plugin 'mattn/emmet-vim'
    Plugin 'christoomey/vim-tmux-navigator'
    Plugin 'scrooloose/syntastic'
    Plugin 'vimwiki'


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
set t_Co=256
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


" Don't backup files in temp directories or shm
if exists('&backupskip')
    set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
endif

" Don't keep swap files in temp directories or shm
if has('autocmd')
    augroup swapskip
        autocmd!
        silent! autocmd BufNewFile,BufReadPre
            \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
            \ setlocal noswapfile
    augroup END
endif

" Don't keep undo files in temp directories or shm
if has('persistent_undo') && has('autocmd')
    augroup undoskip
        autocmd!
        silent! autocmd BufWritePre
            \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
            \ setlocal noundofile
    augroup END
endif

" Don't keep viminfo for files in temp directories or shm
if has('viminfo')
    if has('autocmd')
        augroup viminfoskip
            autocmd!
            silent! autocmd BufNewFile,BufReadPre
                \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
                \ setlocal viminfo=
        augroup END
    endif
endif
