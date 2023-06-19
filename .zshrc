#powerlevel10k instant load fix for z4h
keychain id_rsa --agents ssh  # moved before instant prompt

# OK to perform console I/O before this point.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# From this point on, until zsh is fully initialized, console input won't work and
# console output may appear uncolored.

#It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://githdub.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '7'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'pc'

# Don't start tmux.
zstyle ':z4h:' start-tmux 'no'

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'no'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'no'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

#source fzf conf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
#zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
#zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'
# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs yes

zstyle ':completion:*' menu select

# Start ssh-agent if it's not running yet.
zstyle ':z4h:ssh-agent:' start yes

zstyle ':z4h:term-title:ssh'   preexec '%n@%m: ${1//\%/%%}'
zstyle ':z4h:term-title:ssh'   precmd  '%n@%m: %~'
zstyle ':z4h:term-title:local' preexec '${1//\%/%%}'
zstyle ':z4h:term-title:local' precmd  '%~'



# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/bin:local/bin:usr/bin $path)

# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local
# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
#z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file

#Plugin nonarray
z4h load  ohmyzsh/ohmyzsh/pluginsautojump
z4h load ohmyzsh/ohmyzsh/plugins/brew
z4h load ohmyzsh/ohmyzsh/colored-man-pages
z4h load ohmyzsh/ohmyzsh/fzf
z4h load ohmyzsh/ohmyzsh/plugins/git
z4h load ohmyzsh/ohmyzsh/plugins/gpg-agent
z4h load ohmyzsh/ohmyzsh/plugins/last-working-dir
z4h load ohmyzsh/ohmyzsh/plugins/vscode
z4h load ohmyzsh/ohmyzsh/plugins/z
z4h load ohmyzsh/ohmyzsh/plugins/zsh-autosuggestions
z4h load ohmyzsh/ohmyzsh/plugins/zsh-completions
z4h load ohmyzsh/ohmyzsh/plugins/zsh-syntax-highlighting

# Define key bindings.
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace     Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace

z4h bindkey undo Ctrl+/ Shift+Tab  # undo the last command line change
z4h bindkey redo Alt+/             # redo the last undone command line change

z4h bindkey z4h-cd-back    Alt+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Alt+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Alt+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Alt+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'

# Add flags to existing aliases.
#alias ls="${aliases[ls]:-ls} -A"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu


#Use Bash Aliases in Zsh and Setup zdotdir: .zshrc.d
for file in $HOME/.zshrc.d/*; do
    source "$file"
done

# test

function term () {
    if [ -n "$TMUX" ]; then
        tmux rename-window "$1"
    else
        echo -ne "\033]0;$1\007"
    fi
}


# function chpwd() {
#     if [ -e $PWD/bash_aliases.sh ]; then
#         source $PWD/bash_aliases.sh
#     else
#         unalias -m 'bb-*'
#     fi
# }

zshrc.d/zsh-autosuggestions/src/async.zsh
source .zshrc.d/zsh-async/async.plugin.zsh

#zline editor autosurround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# To customize prompt, run `z4h prompt -p`.
# To customize colors, run `z4h prompt -c`.
# To customize prompt and colors, run `z4h prompt -p -c`.
autoload -Uz promptinit
