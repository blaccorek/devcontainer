#!/bin/bash

set -e

# Install requirements
apt-get update -y && apt-get install -y lsb-release

OS_ID=$(lsb_release --id --short)
OS_RELEASE=$(lsb_release --release --short)

if [ $OS_ID = 'Debian' ]
then
    apt-get install -y curl gnupg

    # Add package to local repo
    echo "deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/${OS_ID}_${OS_RELEASE}/ /" | tee /etc/apt/sources.list.d/shells:fish:release:3.list
    curl -fsSL "https://download.opensuse.org/repositories/shells:fish:release:3/${OS_ID}_${OS_RELEASE}/Release.key" | gpg --dearmor | tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
    
    apt-get update -y
fi

# Install app
apt-get install -y fish
