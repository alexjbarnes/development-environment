set -U fish_user_paths /root/.goenv/shims $fish_user_paths

alias ls="lla"
alias grep="rg"
alias vim="nvim"

# pnpm
set -gx PNPM_HOME "/root/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Add Go packages to PATH
set -gx PATH $PATH (go env GOPATH)/bin
~/.local/bin/mise activate fish | source
