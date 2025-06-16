set -U fish_user_paths /root/.goenv/shims $fish_user_paths

alias ls="lla"
alias grep="rg"
alias vim="nvim"

function ai
    set prefix "You are an AI chat bot accessed from the terminal in a fish shell, please Keep the output very concise and format appropriately fro the terminal: "
    set message $prefix(string join ' ' $argv)
    cody chat -m "$message"
end

# pnpm
set -gx PNPM_HOME "/root/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
