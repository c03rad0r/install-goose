#!/bin/bash

echo "Installing Goose..."

if ! command -v curl &> /dev/null
then
  echo "curl is required to install goose, please install it"
  exit 1
fi

curl -fsSL https://github.com/block/goose/releases/download/stable/download_cli.sh | bash

echo "Goose installation complete."
