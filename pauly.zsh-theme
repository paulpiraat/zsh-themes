local ret_status="%(?:%{$fg_bold[white]%}☻:%{$fg[red]%}☹%s)%{$reset_color%}%{$reset_color%}"
local user_status="%(?:%{$fg[red]%}%m: %{$fg[red]%}%m%s)%{$reset_color%}%{$reset_color%}"

function node_version() {
    if [[ -f 'package.json' ]]; then
        echo "%{$fg[magenta]%}node $(node -v) %{$reset_color%}"
    fi
}

function git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_SUFFIX$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)]"
}

function get_line() {
    date="%D{%Y-%m-%d %I:%M:%S}"
    index=${#date}
    output=""
    character="-"
    columns=$(tput cols)
    while [[ $index -lt $columns ]]; do
        output="$output$character"
        index=$((index+1))
    done
    echo "$output $date"
}

function get_pwd(){
    git_root=$PWD
    while [[ $git_root != / && ! -e $git_root/.git ]]; do
        git_root=$git_root:h
    done
    if [[ $git_root = / ]]; then
        unset git_root
        prompt_short_dir="% ${PWD}"
    else
        parent=${git_root%\/*}
        repo=${PWD#$parent/}
        prompt_short_dir="[%{$fg_bold[blue]%}$repo]%{$reset_color%}"
    fi
    echo "%{$fg[blue]%}$prompt_short_dir%{$reset_color%}"
}

PROMPT='%{$fg_bold[white]%}$(get_line)%{$reset_color%}
$ret_status $user_status %{$reset_clor%}%{$reset_color%}$ %{$fg[black]%}$(node_version)$(get_pwd)$(git_prompt_info) %{$reset_color%}
%{$fg[cyan]%}➜%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ░░ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ▓▓ %{$reset_color%}"