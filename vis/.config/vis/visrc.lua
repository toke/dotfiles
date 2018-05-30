-- load standard vis module, providing parts of the Lua API
require('vis')
require('plugins/vis-ctags/ctags')
require('plugins/vis-fzf-open/fzf-open')
require('plugins/vis-modelines/vis-modelines')

vis.events.subscribe(vis.events.INIT, function()
    -- Your global configuration options
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
    -- Your per window configuration options e.g.
    vis:command('set number on')
    vis:command('set cursorline on')
    vis:command('set expandtab on')
    vis:command('set show-tabs on')
    vis:command('set tabwidth 4')
    vis:command('set autoindent on')
end)

