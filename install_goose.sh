#!/bin/bash

echo "Installing Goose..."

if ! command -v curl &> /dev/null
then
  echo "curl is required to install goose, please install it"
  exit 1
fi

if ! command -v bzip2 &> /dev/null
then
  echo "bzip2 is required to extract goose, installing it now"
  sudo apt update
  sudo apt install -y bzip2
fi

DOWNLOAD_DIR=$(mktemp -d)

curl -fsSL https://github.com/block/goose/releases/download/stable/download_cli.sh | bash -s -- -d $DOWNLOAD_DIR

if [ -f "$DOWNLOAD_DIR/goose" ]; then
  sudo mv "$DOWNLOAD_DIR/goose" "$HOME/.local/bin/goose"
  echo "Goose installed to $HOME/.local/bin"
else
  echo "Goose binary not found in download directory."
  exit 1
fi

rm -rf "$DOWNLOAD_DIR"

# Detect the shell
if [ -f "$HOME/.bashrc" ]; then
    CONFIG_FILE="$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ]; then
    CONFIG_FILE="$HOME/.zshrc"
else
    echo "Could not find .bashrc or .zshrc, creating .bashrc"
    CONFIG_FILE="$HOME/.bashrc"
    touch "$CONFIG_FILE"
fi

# Set the path in the config file
if grep -q "export PATH="$HOME/.local/bin:\\\\\$PATH"" "$CONFIG_FILE"; then
    echo "PATH already configured in $CONFIG_FILE"
else
    echo "export PATH="$HOME/.local/bin:\\\\\$PATH"" >> "$CONFIG_FILE"
    echo "Added export PATH to $CONFIG_FILE"
fi

# Source the file
source "$CONFIG_FILE"
echo "Sourced $CONFIG_FILE to apply changes in the current session"

echo "Please reload your shell (e.g. 'source ~/.bashrc', 'source ~/.zshrc') to apply changes in new sessions."
echo "Goose installation complete."

# Copy secrets.json to the same directory as the script (if it's not there)
if [ ! -f "./secrets.json" ]; then
  echo "secrets.json not found in current directory, exiting"
  exit 1
fi
cp "./secrets.json" "$HOME/secrets.json"

# Call set_env.sh
echo "Setting up environment variables..."
./set_env.sh
