#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

check "default shell is Fish" bash -c "getent passwd $(whoami) | awk -F: '{ print $7 }' | grep '/usr/bin/fish'"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
