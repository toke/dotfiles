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

    set modeline

    set backspace=indent,eol,start

" Default to soft tabs, 4 spaces
    set expandtab
    set sw=4
    set sts=4

    let mapleader = ","
" Except for Makefiles: Hard tabs of width 2
" More exceptions may be found in editorconfig/.editorconfig
    autocmd FileType make set ts=2
    autocmd FileType python set breakindentopt=shift:4

    au BufRead,BufNewFile tmpmsg.* set filetype=mail
    au BufRead,BufNewFile *.pde set filetype=arduino
    au BufRead,BufNewFile *.ino set filetype=arduino


"" CLIPBOARD HANDLING
" system wide copy-paste with ctrl-c ctrl-v
    set clipboard=unnamedplus
" copy and paste
    vmap <C-c> "+yi
    vmap <C-x> "+c
    vmap <C-v> c<ESC>"+p
    imap <C-v> <ESC>"+pa


" Disable comment continuation on paste
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o


" Default to Unix LF line endings
    set ffs=unix

    imap <C-d> <Esc> " leave insert mode with ctrl-d

" I always accidently hit :W instread of :w, so make both work
    command! W write

" Sh" Folding
    set foldmethod=syntax
    set foldcolumn=1
    set foldlevelstart=20


" Plug config
    call plug#begin('~/.local/share/nvim/plugged')
        Plug 'bling/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
        Plug 'lifepillar/vim-solarized8'

        Plug 'fsouza/go.vim'
        Plug 'wting/rust.vim'
        Plug 'elzr/vim-json'
        Plug 'posva/vim-vue'
        Plug 'plasticboy/vim-markdown'
        Plug 'ap/vim-css-color'
        Plug 'pearofducks/ansible-vim'
        Plug 'vim-scripts/vim-vagrant'
        Plug 'python-mode/python-mode' , { 'branch': 'develop' }
        Plug 'plytophogy/vim-virtualenv'
        Plug 'aouelete/sway-vim-syntax'

        Plug 'neomake/neomake'
        Plug 'godlygeek/tabular'
        Plug 'mtth/scratch.vim'
        Plug 'xolox/vim-misc'
        Plug 'majutsushi/tagbar'
        Plug 'scrooloose/nerdtree'
        Plug 'ConradIrwin/vim-bracketed-paste'

        Plug 'tpope/vim-fugitive'
        Plug 'editorconfig/editorconfig-vim'
        Plug 'mattn/emmet-vim'
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

"" VIMWIKI
    let g:vimwiki_list = [
        \ {'path': '~/vimwiki/',
        \ 'template_path': '~/vimwiki/templates/',
        \ 'template_default': 'default',
        \ 'template_ext': '.tpl',
        \ 'syntax': 'markdown',
        \ 'auto_tags': 1,
        \ 'list_margin': 0,
        \ 'vimwiki_auto_chdir': 1,
        \ 'vimwiki_autowriteall': 1,
        \ 'vimwiki_hl_headers': 1,
        \ 'ext': '.md',
        \ 'nested_syntaxes': {'python': 'python', 'c++': 'cpp', 'sh': 'sh', 'go': 'go', 'yaml': 'yaml', 'vim': 'vim', 'sql': 'sql'},
        \ }]
    nnoremap <leader>o mmI:<esc>v$h"oy@o<CR>x`m
    nnoremap <silent> <F3> :exec (&ft == 'vim' ? '' : &ft) . ' ' . getline('.')<CR>
    " vimwiki with markdown support
    let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown',
        \ '.mdown': 'markdown'}
    function! MyVimwikiLinkHandler(link)
        try
          let browser = '/usr/lib/plan9/bin/plumb'
          execute '!start "'.browser.'" ' . a:link
          return 1
        catch
          echo "This can happen for a variety of reasons ..."
        endtry
        return 0
    endfunction

    let g:instant_markdown_autostart = 0	" disable autostart
    map <leader>md :InstantMarkdownPreview<CR>

" Usage Open ~/.vims hover over an entry and `gF`
    function! MoshBookmark()
      redir >> ~/.vims
      echo
      echo strftime("%Y-%b-%d %a %H:%M")
      echo "cd ". $PWD
      echo "vim ". expand("%:p").':'.line('.')
      echo ' word='.expand("<cword>")
      echo ' cline='.getline('.')
      redir END
    endfunction
    :command! MoshBookmark :call MoshBookmark()

" Emnet
" Default: Then type <c-y>, (Ctrly,) after typing zen stuff
    let g:user_emmet_install_global = 0
    autocmd FileType html,css EmmetInstall

" Close quickfix if it is the last open buffer
" Usefull i.E. with my vimwiki autocommit to prevent a single quickfix
" Window open.
    au BufEnter * call MyLastWindow()
    function! MyLastWindow()
      " if the window is quickfix go on
      if &buftype=="quickfix"
        " if this window is last on screen quit without warning
        if winbufnr(2) == -1
          quit!
        endif
      endif
    endfunction

" Execute
    nnoremap <leader>2 :@"<CR>
    vmap <space> "xy:@x<CR>
    vmap l :w !plumb <CR>

" terminal Map ESC to leave insert mode
" :vsplit term://python
    tnoremap <Esc> <C-\><C-n>

" To use `ALT+{h,j,k,l}` to navigate windows from any mode:
    :tnoremap <A-h> <C-\><C-N><C-w>h
    :tnoremap <A-j> <C-\><C-N><C-w>j
    :tnoremap <A-k> <C-\><C-N><C-w>k
    :tnoremap <A-l> <C-\><C-N><C-w>l
    :inoremap <A-h> <C-\><C-N><C-w>h
    :inoremap <A-j> <C-\><C-N><C-w>j
    :inoremap <A-k> <C-\><C-N><C-w>k
    :inoremap <A-l> <C-\><C-N><C-w>l
    :nnoremap <A-h> <C-w>h
    :nnoremap <A-j> <C-w>j
    :nnoremap <A-k> <C-w>k
    :nnoremap <A-l> <C-w>l


"======Solarized theme============
    syntax on
    colorscheme solarized8
    let g:solarized_extra_hi_groups=1
    let g:solarized_statusline="low"
    let g:solarized_term_italics=1
    let g:solarized_termtrans=1


    if (has("termguicolors"))
      set termguicolors
    endif

" Enable mouse support
    if has('mouse')
      set mouse=a
    endif

" ow trailing whitepace and spaces before a tab:
    highlight ExtraWhitespace ctermbg=red guibg=red
    autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL


    highlight comment ctermfg=grey
    highlight comment cterm=italic


" CUSTOM KEYBINDINGS AND COMMANDS
"
" NERDTree
    nmap <F2> :NERDTreeToggle<CR>
" Tagbar
    nmap <F8> :TagbarToggle<CR>
    map <F12> :set number!<Bar>set number?<CR>

" Window Tab handling
    nnoremap th  :tabfirst<CR>
    nnoremap tj  :tabnext<CR>
    nnoremap tk  :tabprev<CR>
    nnoremap tl  :tablast<CR>
    nnoremap tt  :tabedit<Space>
    nnoremap tn  :tabnext<Space>


" Command named R to ececute a command and output to a scratch buffer
" Source: https://vim.fandom.com/wiki/Append_output_of_an_external_command
    command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>


"" NEOMAKE
    function! MyOnBattery()
      if filereadable('/sys/class/power_supply/AC/online')
        return readfile('/sys/class/power_supply/AC/online') == ['0']
      elseif filereadable('/sys/class/power_supply/ADP1/online')
        return readfile('/sys/class/power_supply/ADP1/online') == ['0']
      endif

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


" Autorenew
    autocmd BufWritePost ~/.config/bmfiles,~/.config/bmdirs !shortcuts

" Autocommit for vimwiki
    if has("autocmd")
        augroup vimwiki
            autocmd!
            autocmd BufEnter ~/vimwiki/** silent!  lcd %:p:h
            autocmd BufWritePost ~/vimwiki/**
                        \ NeomakeSh vimwiki-autocommit
        augroup end
    endif


    "    autocmd BufEnter **/.config/waybar/config set ft=json
" Autoreload and also grouping to prevent multiple reloads
    if has("autocmd")
        augroup myvimrchooks
            autocmd!
            autocmd bufwritepost .vimrc source ~/.vimrc
        augroup end
    endif

    if has("autocmd")
        augroup textfile
          autocmd!
          autocmd filetype markdown :setlocal spell spelllang=en_us,de_de | syntax clear
          autocmd filetype text :setlocal spell spelllang=en_us,de_de | syntax clear
        augroup end
    endif

" Template handling for vim
" Idea from: https://shapeshed.com/vim-templates/
    if has("autocmd")
      augroup templates
        autocmd!
        autocmd BufNewFile *.sh 0r ~/.vim/templates/skeleton.sh
      augroup END
    endif

    let g:virtualenv_directory = '~/.virtualenvs'
    let g:virtualenv_auto_activate = 'yes'
    let g:pymode_python = 'python3'
    let g:pymode_virtualenv = 1
    let g:pymode_virtualenv_path = $VIRTUAL_ENV
    let g:powerline_pycmd="python3"


