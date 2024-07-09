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
    git pull origin main
    cd /data/ente/web
    git submodule update --recursive
fi

# Install dependencies
yarn install

# Build the application
if [ -d "/data/ente/web/apps/photos/out" ]; then
    echo "Removing previous build directory."
    rm -rf /data/ente/web/apps/photos/out
fi

yarn build:photos

# Execute the command provided as arguments to the entrypoint (if any)
exec "$@"
