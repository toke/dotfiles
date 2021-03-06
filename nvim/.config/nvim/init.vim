" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P


let mapleader =","

if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ~/.config/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
endif

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

" Enable Goyo by default for mutt writting
" Goyo's width will be the line limit in mutt.
    autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
    autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo \| set bg=light


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
        Plug 'dylanaraps/wal.vim'

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
        Plug 'junegunn/goyo.vim'
        Plug 'tpope/vim-fugitive'
        Plug 'editorconfig/editorconfig-vim'
        Plug 'mattn/emmet-vim'
        Plug 'vimwiki/vimwiki'
    call plug#end()


    filetype plugin on
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
    function! VimwikiLinkHandler(link)
        if a:link =~ ":"
            try
              let browser = '/usr/lib/plan9/bin/plumb'
              execute '!"'.browser.'" -s vimwiki ' . a:link
              return 1
            catch
              echo "This can happen for a variety of reasons ..."
            endtry
        endif
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

" VIM Execute
" Execute contents of Clipboard (Register ")
    nnoremap <leader>2 :@"<CR>
" Execute visual selection as vim command
    vmap <space> "xy:@x<CR>
" Currently BROKEN FIXME: plumb does not support piping into it
   "vmap l :w !plumb <CR>

" Goyo plugin makes text more readable when writing prose:
    map <leader>f :Goyo \| set bg=light \| set linebreak<CR>
" Spell-check set to <leader>o, 'o' for 'orthography':
    map <leader>o :setlocal spell! spelllang=en_us,de_de<CR>
" Nerd tree
    map <leader>n :NERDTreeToggle<CR>
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Replace all is aliased to S.
    nnoremap S :%s//g<Left><Left>

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


" Navigation with guides taken from luke smith
    inoremap <leader><leader> <Esc>/<++><Enter>"_c4l
    vnoremap <leader><leader> <Esc>/<++><Enter>"_c4l
    map <leader><leader> <Esc>/<++><Enter>"_c4l

" autocomplete the fucking parenthesis and curly shit automatically
" inpired by numenra
    inoremap " ""<left>
    inoremap ' ''<left>
    inoremap ( ()<left>
    inoremap [ []<left>
    inoremap { {}<left>
    inoremap {<CR> {<CR>}<ESC>O
    inoremap {;<CR> {<CR>};<ESC>O

" escape with autocompleted parenthesis 
    inoremap ;; <right><ESC>a

"======Solarized theme============
    syntax on
    "colorscheme solarized8
    colorscheme wal
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

    "noremap <leader>u :w<Home>silent <End> !urlview<CR>
    noremap <leader>u :w<Home> <End> !urlview<CR>

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
    "autocmd BufWritePost ~/.plumbing ! cat % | 9p write plumb/rules
    autocmd BufWritePost ~/.plumbing :w !9p write plumb/rules
    noremap <leader>b :!plumb <cWORD><CR>

" Autocommit for vimwiki
"    if has("autocmd")
        augroup myvimwiki
            autocmd!
            autocmd BufEnter ~/vimwiki/** silent!  lcd %:p:h
            autocmd BufWritePost ~/vimwiki/**
                        \ NeomakeSh! vimwiki-autocommit
            autocmd BufLeave ~/vimwiki/** :cclose
        augroup end
"    endif


"    autocmd BufEnter **/.config/waybar/config set ft=json
" Autoreload and also grouping to prevent multiple reloads
    if has("autocmd")
        augroup myvimrchooks
            autocmd!
            autocmd bufwritepost .vimrc source ~/.vimrc
        augroup end
    endif

    highlight clear SpellBad
    highlight SpellBad cterm=underline
    " Set style for gVim
    highlight SpellBad gui=undercurl, guifg=orange
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

"""HTML
    autocmd FileType html inoremap ,b <b></b><Space><++><Esc>FbT>i
    autocmd FileType html inoremap ,it <em></em><Space><++><Esc>FeT>i
    autocmd FileType html inoremap ,1 <h1></h1><Enter><Enter><++><Esc>2kf<i
    autocmd FileType html inoremap ,2 <h2></h2><Enter><Enter><++><Esc>2kf<i
    autocmd FileType html inoremap ,3 <h3></h3><Enter><Enter><++><Esc>2kf<i
    autocmd FileType html inoremap ,p <p></p><Enter><Enter><++><Esc>02kf>a
    autocmd FileType html inoremap ,a <a<Space>href=""><++></a><Space><++><Esc>14hi
    autocmd FileType html inoremap ,e <a<Space>target="_blank"<Space>href=""><++></a><Space><++><Esc>14hi
    autocmd FileType html inoremap ,ul <ul><Enter><li></li><Enter></ul><Enter><Enter><++><Esc>03kf<i
    autocmd FileType html inoremap ,li <Esc>o<li></li><Esc>F>a
    autocmd FileType html inoremap ,ol <ol><Enter><li></li><Enter></ol><Enter><Enter><++><Esc>03kf<i
    autocmd FileType html inoremap ,im <img src="" alt="<++>"><++><esc>Fcf"a
    autocmd FileType html inoremap ,td <td></td><++><Esc>Fdcit
    autocmd FileType html inoremap ,tr <tr></tr><Enter><++><Esc>kf<i
    autocmd FileType html inoremap ,th <th></th><++><Esc>Fhcit
    autocmd FileType html inoremap ,tab <table><Enter></table><Esc>O
    autocmd FileType html inoremap ,gr <font color="green"></font><Esc>F>a
    autocmd FileType html inoremap ,rd <font color="red"></font><Esc>F>a
    autocmd FileType html inoremap ,yl <font color="yellow"></font><Esc>F>a
    autocmd FileType html inoremap ,dt <dt></dt><Enter><dd><++></dd><Enter><++><esc>2kcit
    autocmd FileType html inoremap ,dl <dl><Enter><Enter></dl><enter><enter><++><esc>3kcc
    autocmd FileType html inoremap &<space> &amp;<space>
    autocmd FileType html inoremap á &aacute;
    autocmd FileType html inoremap é &eacute;
    autocmd FileType html inoremap í &iacute;
    autocmd FileType html inoremap ó &oacute;
    autocmd FileType html inoremap ú &uacute;
    autocmd FileType html inoremap ä &auml;
    autocmd FileType html inoremap ë &euml;
    autocmd FileType html inoremap ï &iuml;
    autocmd FileType html inoremap ö &ouml;
    autocmd FileType html inoremap ü &uuml;
    autocmd FileType html inoremap ã &atilde;
    autocmd FileType html inoremap ẽ &etilde;
    autocmd FileType html inoremap ĩ &itilde;
    autocmd FileType html inoremap õ &otilde;
    autocmd FileType html inoremap ũ &utilde;
    autocmd FileType html inoremap ñ &ntilde;
    autocmd FileType html inoremap à &agrave;
    autocmd FileType html inoremap è &egrave;
    autocmd FileType html inoremap ì &igrave;
    autocmd FileType html inoremap ò &ograve;
    autocmd FileType html inoremap ù &ugrave;


"MARKDOWN
    autocmd Filetype markdown,rmd map <leader>w yiWi[<esc>Ea](<esc>pa)
    autocmd Filetype markdown,rmd inoremap ,n ---<Enter><Enter>
    autocmd Filetype markdown,rmd inoremap ,b ****<++><Esc>F*hi
    autocmd Filetype markdown,rmd inoremap ,s ~~~~<++><Esc>F~hi
    autocmd Filetype markdown,rmd inoremap ,e **<++><Esc>F*i
    autocmd Filetype markdown,rmd inoremap ,h ====<Space><++><Esc>F=hi
    autocmd Filetype markdown,rmd inoremap ,i ![](<++>)<++><Esc>F[a
    autocmd Filetype markdown,rmd inoremap ,a [](<++>)<++><Esc>F[a
    autocmd Filetype markdown,rmd inoremap ,1 #<Space><Enter><++><Esc>kA
    autocmd Filetype markdown,rmd inoremap ,2 ##<Space><Enter><++><Esc>kA
    autocmd Filetype markdown,rmd inoremap ,3 ###<Space><Enter><++><Esc>kA
    autocmd Filetype markdown,rmd inoremap ,l --------<Enter>
    autocmd Filetype rmd inoremap ,r ```{r}<CR>```<CR><CR><esc>2kO
    autocmd Filetype rmd inoremap ,p ```{python}<CR>```<CR><CR><esc>2kO
    autocmd Filetype rmd inoremap ,c ```<cr>```<cr><cr><esc>2kO
