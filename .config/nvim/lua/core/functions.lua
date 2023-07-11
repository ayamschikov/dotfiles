-- " Test helpers from Gary Bernhardt's screen cast:
-- " https://www.destroyallsoftware.com/screencasts/catalog/file-navigation-in-vim
-- " https://www.destroyallsoftware.com/file-navigation-in-vim.html
vim.cmd(
     [[
function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    " :silent !echo;echo;echo;echo;echo
    " FOR RAILS
    exec VimuxRunCommand("RAILS_ENV=test bin/rspec " . a:filename)
    " exec VimuxRunCommand("bin/rspec " . a:filename)
endfunction
     ]])

vim.cmd(
     [[
function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction
     ]])

vim.cmd(
     [[
function! RunTestFile(...)
    let prev_line = line('.')
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_spec_file = match(expand("%"), '_spec.rb$') != -1
    if !in_spec_file
        return
    end

    call SetTestFile()
    call RunTests(t:grb_test_file . command_suffix)
    exe "normal!" prev_line . "gg" . "zz"
endfunction
     ]])

vim.cmd(
     [[
function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
    exe "normal!" spec_line_number . "gg" . "zz"
endfunction
     ]])

vim.cmd(
     [[
function! RunRubocopFile(...)
    let prev_line = line('.')
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    call SetRubocopFile()
    call RunRubocop(t:grb_rubocop_file . command_suffix)
    exe "normal!" prev_line . "gg" . "zz"
endfunction
     ]])

vim.cmd(
     [[
function! RunRubocopFileA(...)
    let prev_line = line('.')
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    call SetRubocopFile()
    call RunRubocopA(t:grb_rubocop_file . command_suffix)
    exe "normal!" prev_line . "gg" . "zz"
endfunction
     ]])


vim.cmd(
     [[
function! SetRubocopFile()
    " Set the spec file that tests will be run for.
    let t:grb_rubocop_file=@%
endfunction
     ]])

vim.cmd(
     [[
function! RunRubocop(filename)
    " Write the file and run tests for the given filename
    :w
    " :silent !echo;echo;echo;echo;echo
    exec VimuxRunCommand("bundle exec rubocop -a -f fuubar " . a:filename)
endfunction
     ]])

vim.cmd(
     [[
function! RunRubocopA(filename)
    " Write the file and run tests for the given filename
    :w
    " :silent !echo;echo;echo;echo;echo
    exec VimuxRunCommand("bundle exec rubocop -A -f fuubar " . a:filename)
endfunction
     ]])

vim.cmd(
     [[
" git conflict resolution
function! LeaveFirst()
    exe "g/=====/,/>>>>/d" | exe "g/<<<<</d"
endfunction
     ]])

vim.cmd(
     [[
function! LeaveLast()
    exe "g/<<<<</,/=====/d" | exe "g/>>>>/d"
endfunction
     ]])

-- " " Jump to last cursor position unless it's invalid or in an event handler
-- " autocmd BufReadPost *
-- "   \ if line("'\"") > 0 && line("'\"") <= line("$") |
-- "   \   exe "normal g`\"" |
-- "   \ endif
