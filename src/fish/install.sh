#!/bin/bash

set -e

CONFIGURE_FISH_AS_DEFAULT_SHELL="${CONFIGUREFISHASDEFAULTSHELL:-"false"}"
USERNAME=${USERNAME:-"automatic"}

source /etc/os-release

if [ $ID = 'debian' ]
then
    apt-get update && apt-get install -y curl gnupg
    OS_ID=$(tr '[:lower:]' '[:upper:]' <<< ${ID:0:1})${ID:1}

    # Add package to local repo
    echo "deb http://download.opensuse.org/repositories/shells:/fish:/release:/4/${OS_ID}_${VERSION_ID}/ /" \
        | tee /etc/apt/sources.list.d/shells:fish:release:4.list

    curl -fsSL "https://download.opensuse.org/repositories/shells:fish:release:4/${OS_ID}_${VERSION_ID}/Release.key" \
        | gpg --dearmor \
        | tee /etc/apt/trusted.gpg.d/shells_fish_release_4.gpg > /dev/null
fi

if [ $ID = 'ubuntu' ]
then
    apt-get update && apt-get install -y curl gnupg
    # Add both required keys for fish-shell PPA
    curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x59FDA1CE1B84B3FAD89366C027557F056DC33CA5" \
        | gpg --dearmor \
        | tee /etc/apt/trusted.gpg.d/fish-shell-release-4.gpg > /dev/null
    curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x73c9fcc9e2bb48da" \
        | gpg --dearmor \
        | tee -a /etc/apt/trusted.gpg.d/fish-shell-release-4.gpg > /dev/null
    echo "deb https://ppa.launchpadcontent.net/fish-shell/release-4/${ID} ${UBUNTU_CODENAME} main" \
        | tee /etc/apt/sources.list.d/fish-shell-release-4.list
    echo "deb-src https://ppa.launchpadcontent.net/fish-shell/release-4/${ID} ${UBUNTU_CODENAME} main" \
        | tee -a /etc/apt/sources.list.d/fish-shell-release-4.list
fi

# Install app
apt-get update -y && apt-get install -y fish

# Copied from devcontainer-features common-utils
## (https://github.com/devcontainers/features/blob/main/src/common-utils/main.sh#L392)
# ------
# If in automatic mode, determine if a user already exists, if not use vscode
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    if [ "${_REMOTE_USER}" != "root" ]; then
        USERNAME="${_REMOTE_USER}"
    else
        USERNAME=""
        POSSIBLE_USERS=("devcontainer" "vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
        for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
            if id -u ${CURRENT_USER} > /dev/null 2>&1; then
                USERNAME=${CURRENT_USER}
                break
            fi
        done
        if [ "${USERNAME}" = "" ]; then
            USERNAME=vscode
        fi
    fi
elif [ "${USERNAME}" = "none" ]; then
    USERNAME=root
    USER_UID=0
    USER_GID=0
fi
# ------

if [ $CONFIGURE_FISH_AS_DEFAULT_SHELL = 'true' ]
then
    chsh --shell /usr/bin/fish ${USERNAME}
fi
