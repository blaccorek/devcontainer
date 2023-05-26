#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

check "fish is the default shell" bash -c 'echo $SHELL'

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
