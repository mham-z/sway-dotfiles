function gclone --wraps='git clone --depth=1' --description 'alias gclone git clone --depth=1'
    git clone --depth=1 $argv
end
