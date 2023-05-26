#!/bin/bash

set -e

GITHUB_USERNAME=${USER}
DEST_FOLDER=${DESTINATION}

apt-get update -y && apt-get install -y curl

sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ${DEST_FOLDER}

if [[ ! -z ${GITHUB_USERNAME} ]]
then
    chezmoi init https://github.com/${GITHUB_USERNAME}/dotfiles.git
fi
