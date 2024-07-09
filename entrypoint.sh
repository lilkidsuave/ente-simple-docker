#!/bin/sh
# Exit on any error
set -e

# Clone the repository if it doesn't exist
if [ ! -d "/data/ente/.git" ]; then
    git clone https://github.com/ente-io/ente.git /data/ente
    cd /data/ente/web
    git submodule update --init --recursive
else
    cd /data/ente
    # Remove any existing lock files
    rm -f .git/index.lock
    # Check if HEAD exists before attempting reset
    if git rev-parse --verify HEAD >/dev/null 2>&1; then
        git reset --hard HEAD
    else
        echo "HEAD not found. Skipping reset."
    fi

    # Force checkout of the main branch to ensure a clean state
    git checkout -f main
    git pull origin main
    cd /data/ente/web
    git submodule update --recursive
fi

# Install dependencies
yarn install

# Install peer dependencies
yarn add @mui/material@^5.4.1 @mui/system@^5.4.1 react@^17.0.2 react-dom@^17.0.2

# Ensure photoswipe is installed
yarn add photoswipe

# Build the application
if [ -d "/data/ente/web/apps/photos/out" ]; then
    echo "Removing previous build directory."
    rm -rf /data/ente/web/apps/photos/out
fi

yarn build:photos

# Execute the command provided as arguments to the entrypoint (if any)
exec "$@"
