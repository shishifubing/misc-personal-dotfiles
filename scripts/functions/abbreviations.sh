#!/usr/bin/env bash

# systemctl
sy() { sudo systemctl "${@}"; }

# trash management
r() { gio trash "${@}"; }

# kubernetes
k() { kubectl "${@}"; }
kd() { kubectl describe "${@}"; }
kg() { kubectl get "${@}"; }
ka() { kubectl apply "${@}"; }
kl() { kubectl logs "${@}"; }
ke() { kubectl edit "${@}"; }

# st in tabbed
#[[ -z $TABBED_XID ]] || export TABBED_XID=$(tabbed -d)
#st -w "$TABBED_XID"
stt() { tabbed -r 2 st -w ""; }

# default compile command
mi() { make && sudo make install; }

# vim
v() { if [[ "$(which nvim)" ]]; then nvim "${@}" else vim "${@}"; fi; }

s() { sudo --set-home --preserve-env -u "${USER}" bash -c "${@}"; }

g() { grep --color=always "${@}"; }

# kde

kde_start() { kstart plasmashell; }
kde_stop() { kquitapp5 plasmashell; }
kde_restart() { kde_stop && kde_start; }

# code-oss
co() {

    local workspace="${HOME}/dotfiles/configs/vscode_workspace.code-workspace"

    code "${workspace}" &

}

db() {

    if [[ -n "${DATABASE_KEY}" ]]; then
        local choice=$(
            echo "
                PRAGMA key = '${DATABASE_KEY}';
                SELECT location, login FROM passwords;
            " |
                sqlcipher ~/Repositories/dot-files/db.db |
                awk 'NR > 3' | dmenu -l 5
        )
        echo "
            PRAGMA key = '${DATABASE_KEY}';
            SELECT password FROM passwords WHERE login==\"${choice}\"
        " |
            sqlcipher "${HOME}/Repositories/dot-files/db.db" |
            xclip -sel clip
    fi

}
