#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# 1. Install build-essential (if needed)
if ! command_exists make; then
  echo "make is not installed. Installing build-essential..."
  sudo apt update
  sudo apt install -y build-essential
fi

# 2. Create a directory to store OpenSSL 1.1
mkdir -p $HOME/opt
cd $HOME/opt

# 3. Download the latest 1.1.1 version (check for latest on openssl.org)
wget https://www.openssl.org/source/openssl-1.1.1w.tar.gz  # Update if a newer version is available
tar -zxvf openssl-1.1.1w.tar.gz
cd openssl-1.1.1w

# 4. Configure and build (KEY CHANGE: Add --libdir)
./config --prefix=$HOME/opt/openssl-1.1.1w --openssldir=$HOME/opt/openssl-1.1.1w --libdir=lib shared # Add --libdir

make
make test
sudo make install

# 5. Set the LD_LIBRARY_PATH (important!)
export LD_LIBRARY_PATH=$HOME/opt/openssl-1.1.1w/lib:$LD_LIBRARY_PATH

# 6. Add the export to your .bashrc (or .zshrc) for persistence
echo "export LD_LIBRARY_PATH=$HOME/opt/openssl-1.1.1w/lib:$LD_LIBRARY_PATH" >> ~/.bashrc  # Or ~/.zshrc

if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

# 7. Source your .bashrc to apply the changes
source ~/.bashrc

sudo ./install_goose.sh

# 8. Try running goose again (after navigating back to your goose directory)
cd ~/goose  # Go back to the goose directory (KEY CHANGE)

# 9. Check if goose is in your PATH (KEY CHANGE)
if ! command_exists goose; then
  echo "goose command not found. Make sure it's installed and in your PATH."
  # Add /usr/local/bin to your PATH if it's not already there.
  if [[ ! "$PATH" == *"/usr/local/bin"* ]]; then
      export PATH=$PATH:/usr/local/bin
      echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc # Add to .bashrc for persistence
      source ~/.bashrc
  fi
fi

goose version # Now try it.
