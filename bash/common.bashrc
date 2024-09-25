#!/usr/bin/env bash

# Global /etc/bashrc {{{
if [ -f "/etc/bashrc" ]; then
  source "/etc/bashrc"
fi
# }}}

# Bash Colors {{{
if [ -x "/usr/bin/dircolors" ]; then
  test -r "${HOME}/.dircolors" && eval "$(dircolors -b "${HOME}/.dircolors")"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi
# }}}

# System Path {{{
if [ -f "${HOME}/.bashrc_local" ]; then
  source "${HOME}/.bashrc_local"
fi

if [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]]; then
  PATH="${PATH}:${HOME}/.local/bin"
  export PATH
fi

if [[ ":${LD_LIBRARY_PATH}:" != *":${HOME}/.local/lib:"* ]]; then
  LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${HOME}/.local/lib"
  export LD_LIBRARY_PATH
fi
# }}}

# Solana {{{
if [[ -d "$HOME/.local/share/solana/install" ]]; then
  export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
fi
# }}}

# Cargo {{{
if [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi
# }}}

# Node {{{
if [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  source "$NVM_DIR/nvm.sh"
  # Bash completion
  source "$NVM_DIR/bash_completion"
fi
# }}}

# pyenv {{{
if [[ -d "$HOME/.pyenv" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi
# }}}

# Kerberos {{{
if [[ -d "$HOME/.local/krb5" ]]; then
  KRB5_ROOT="$HOME/.local/krb5"
  OSSH_ROOT="$HOME/.local/ossh"
  export PATH="$KRB5_ROOT/bin:$OSSH_ROOT/bin:$PATH"
  export KRB5_CONFIG="$KRB5_ROOT/etc/krb5.conf"
fi
# }}}

# texlive {{{
if [[ -d "$HOME/.local/texlive" ]]; then
  export TEXLIVE_ROOT="$HOME/.local/texlive/2023/bin/x86_64-linux/"
  export PATH="$TEXLIVE_ROOT:$PATH"
fi
# }}}

# anaconda {{{
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/anaconda3/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
# }}}

# GPG Tools {{{
# Necessary for TTY-based PIN entry
export GPG_TTY=$(tty)

gpg-encrypt () {
  default=0x12813A70E33FDA8A
  output=$(pwd)/"${1}".$(date +%s).enc
  gpg --encrypt --armor --output ${output} --recipient ${default} "${1}" \
    && echo "${1} => ${output}"
}

gpg-decrypt () {
  output=$(echo "${1}" | rev | cut -c16- | rev)
  gpg --decrypt --output ${output} "${1}" \
    && echo "${1} => ${output}"
}

gpg-sign () {
  output=$(pwd)/"${1}".$(date +%s).sig
  gpg --detach-sig --armor --output ${output} "${1}" \
    && echo "${1} => ${output}"
}
# }}}

