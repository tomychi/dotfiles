set -g fish_greeting

# PATH (non-interactive safe)
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path -g $PNPM_HOME

if status is-interactive
    type -q eza; and alias ls "eza --group-directories-first --icons=auto"
    type -q eza; and alias tree "eza -T --icons=auto"
    type -q eza; and alias ll "eza -l --git --icons=auto --group-directories-first"
    type -q eza; and alias la "eza -la --git --icons=auto --group-directories-first"
    type -q bat; and alias cat "bat --style=plain --paging=never"
    type -q nvim; and alias vim nvim

    alias grep "grep --color=auto"
    alias dotfiles "git --git-dir $HOME/.dotfiles/ --work-tree $HOME"

    type -q starship; and starship init fish | source
end

# Google Cloud SDK
if test -f "$HOME/google-cloud-sdk/path.fish.inc"
    source "$HOME/google-cloud-sdk/path.fish.inc"
end
