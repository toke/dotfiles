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
"vmap <c-c> "+y
"nmap <c-v> "+p

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



call plug#begin('~/.local/share/nvim/plugged')
    Plug 'bling/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'altercation/vim-colors-solarized'

    Plug 'fsouza/go.vim'
    Plug 'wting/rust.vim'
    Plug 'elzr/vim-json'
    Plug 'posva/vim-vue'
    Plug 'PotatoesMaster/i3-vim-syntax'
    Plug 'plasticboy/vim-markdown'
    Plug 'ap/vim-css-color'
    Plug 'pearofducks/ansible-vim'
    Plug 'vim-scripts/vim-vagrant'
    Plug 'python-mode/python-mode' , { 'branch': 'develop' }
    Plug 'plytophogy/vim-virtualenv'

    Plug 'neomake/neomake'
    Plug 'godlygeek/tabular'
    Plug 'mtth/scratch.vim'
    Plug 'xolox/vim-misc'
    Plug 'majutsushi/tagbar'
    Plug 'scrooloose/nerdtree'

    Plug 'tpope/vim-fugitive'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'mattn/emmet-vim'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'vimwiki/vimwiki'
call plug#end()

filetype plugin on
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


let g:vimwiki_list = [{'path': '~/vimwiki/', 'template_path': '~/vimwiki/templates/',
    \ 'template_default': 'default', 'template_ext': '.tpl',
    \ 'syntax': 'markdown', 'ext': '.md'}]

" vimwiki with markdown support
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown',
    \ '.mdown': 'markdown'}

let g:instant_markdown_autostart = 0	" disable autostart
map <leader>md :InstantMarkdownPreview<CR>


" Emnet
" Default: Then type <c-y>, (Ctrly,) after typing zen stuff
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

" Window Tab handling
nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabnext<Space>


"======Solarized theme============
syntax on
syntax enable
let g:solarized_termtrans = 1
set background=dark
set t_Co=256
let g:solarized_termcolors=256
colorscheme solarized

" Enable mouse support
if has('mouse')
  set mouse=a
endif

" NERDTree
nmap <F2> :NERDTreeToggle<CR>
" Tagbar
nmap <F8> :TagbarToggle<CR>


" Syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 0
"let g:syntastic_check_on_wq = 0

function! MyOnBattery()
  return readfile('/sys/class/power_supply/AC/online') == ['0']
endfunction

if MyOnBattery()
  call neomake#configure#automake('w')
else
  call neomake#configure#automake('nw', 1000)
endif
let g:neomake_open_list = 2


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

let g:virtualenv_directory = '/home/toke/.virtualenvs'
let g:virtualenv_auto_activate = 'yes'
let g:pymode_python = 'python3'
let g:pymode_virtualenv = 1
let g:pymode_virtualenv_path = $VIRTUAL_ENV
let g:powerline_pycmd="python3"
