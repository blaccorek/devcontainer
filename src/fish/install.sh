#!/bin/bash

set -e

source /etc/os-release

if [ $ID = 'Debian' ]
then
    apt-get install -y curl gnupg

    # Add package to local repo
    echo "deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/${OS_ID}_${OS_RELEASE}/ /" \
        | tee /etc/apt/sources.list.d/shells:fish:release:3.list

    curl -fsSL "https://download.opensuse.org/repositories/shells:fish:release:3/${OS_ID}_${OS_RELEASE}/Release.key" \
        | gpg --dearmor \
        | tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
fi

# Install app
apt-get update -y && apt-get install -y fish

if [ $CONFIGURE_FISH_AS_DEFAULT_SHELL = 'true' ]
then
    chsh --shell /usr/bin/fish ${USERNAME}
fi
