# 1. Create a directory to store OpenSSL 1.1
mkdir $HOME/opt
cd $HOME/opt

# 2. Download the latest 1.1.1 version (check for latest on openssl.org)
wget https://www.openssl.org/source/openssl-1.1.1w.tar.gz  # Use the latest 1.1.1 release
tar -zxvf openssl-1.1.1w.tar.gz
cd openssl-1.1.1w

# 3. Configure and build
./config --prefix=$HOME/opt/openssl-1.1.1w --openssldir=$HOME/opt/openssl-1.1.1w shared  # Important: Install to a custom prefix and enable shared libraries
make
make test  # Run the tests to ensure everything is okay
make install

# 4. Set the LD_LIBRARY_PATH (important!)
export LD_LIBRARY_PATH=$HOME/opt/openssl-1.1.1w/lib:$LD_LIBRARY_PATH

# 5. Add the export to your .bashrc (or .zshrc) for persistence
echo "export LD_LIBRARY_PATH=$HOME/opt/openssl-1.1.1w/lib:$LD_LIBRARY_PATH" >> ~/.bashrc  # Or ~/.zshrc if you use Zsh

# 6. Source your .bashrc to apply the changes
source ~/.bashrc

# 7. Try running goose again
goose version
