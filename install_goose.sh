#!/bin/bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

install_goose() {
  echo "Installing Goose..."

  # 1. Check and install bzip2 (if needed)
  if ! command_exists bzip2; then
    echo "bzip2 is not installed. Installing bzip2..."
    sudo apt update
    sudo apt install -y bzip2
  fi

  # 2. Try the automated script first (since you have curl)
  if command_exists curl; then
    if curl -fsSL https://github.com/block/goose/releases/download/stable/download_cli.sh | bash; then
      echo "Goose installed successfully using the script."
      return 0 # Success
    else
      echo "Automated installation script failed. Continuing with manual install..."
    fi
  fi

  # 3. Manual Installation (using the downloaded binary)
  curl -fsSL https://github.com/block/goose/releases/download/stable/download_cli.sh | bash
  binary_name="goose-x86_64-unknown-linux-gnu.tar.bz2"  # The exact filename you have
  extracted_dir="goose-x86_64-unknown-linux-gnu" # The directory it extracts to

  # ***KEY CHANGE***: Move the downloaded binary to the current directory
  mv "$HOME/goose/$binary_name" . 2>/dev/null # Suppress error if file doesn't exist

  if [[ -f "$binary_name" ]]; then
    echo "Found the binary: $binary_name"
  else
    echo "Binary $binary_name not found.  Make sure it's in the current directory."
    return 1
  fi

  if [[ -d "$extracted_dir" ]]; then
      echo "Removing old extracted directory: $extracted_dir"
      rm -rf "$extracted_dir"
  fi

  tar -xvf "$binary_name"

  if [[ -d "$extracted_dir" ]]; then
    echo "Extracted to: $extracted_dir"
  else
    echo "Extraction failed."
    return 1
  fi

  goose_binary_path="$extracted_dir/goose" # Path to the binary

  if [[ -f "$goose_binary_path" ]]; then
    sudo mv "$goose_binary_path" /usr/local/bin/goose
    echo "Goose installed to /usr/local/bin"
  else
    echo "Goose binary not found after extraction."
    return 1
  fi

   # 4. Install libxcb1 (or the correct library)
  if ! command_exists libxcb1; then # Check if libxcb1 is installed
      echo "Installing libxcb1 dependency..."
      sudo apt update
      sudo apt install -y libxcb1 # Install the library
  fi


  rm -rf "$extracted_dir" "$binary_name" # Clean up

  echo "Installation complete."
  goose version
  return 0
}


sudo apt install -y libxcb1
install_goose
