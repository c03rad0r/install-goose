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
  sudo mv "$DOWNLOAD_DIR/goose" /usr/local/bin/goose
  echo "Goose installed to /usr/local/bin"
else
  echo "Goose binary not found in download directory."
  exit 1
fi

rm -rf "$DOWNLOAD_DIR"

echo "Goose installation complete."
