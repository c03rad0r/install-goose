#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# 1. Install build-essential (if needed)
if ! command_exists make; then
  echo "make is not installed. Installing build-essential..."
  sudo apt update  # Update package list (good practice)
  sudo apt install -y build-essential
fi

# 2. Create a directory to store OpenSSL 1.1
mkdir -p $HOME/opt  # -p creates parent directories if needed
cd $HOME/opt

# 3. Download the latest 1.1.1 version (check for latest on openssl.org)
wget https://www.openssl.org/source/openssl-1.1.1w.tar.gz  # Check for latest and update the filename
tar -zxvf openssl-1.1.1w.tar.gz
cd openssl-1.1.1w

# 4. Configure and build
./config --prefix=$HOME/opt/openssl-1.1.1w --openssldir=$HOME/opt/openssl-1.1.1w shared
make
make test  # Run the tests
sudo make install # Install with sudo

# 5. Set the LD_LIBRARY_PATH (important!)
export LD_LIBRARY_PATH=$HOME/opt/openssl-1.1.1w/lib:$LD_LIBRARY_PATH

# 6. Add the export to your .bashrc (or .zshrc) for persistence
echo "export LD_LIBRARY_PATH=$HOME/opt/openssl-1.1.1w/lib:$LD_LIBRARY_PATH" >> ~/.bashrc  # Or ~/.zshrc

# 7. Source your .bashrc to apply the changes
source ~/.bashrc

# 8. Try running goose again (after navigating back to your goose directory)
cd ~/goose # Go back to the goose directory
goose version
