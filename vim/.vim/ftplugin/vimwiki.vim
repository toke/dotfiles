augroup vimwiki
    au! BufRead ~/vimwiki/index.wiki !git pull
    au! BufWritePost ~/vimwiki/* !git commit -am "Auto commit + push.";git push
augroup END
