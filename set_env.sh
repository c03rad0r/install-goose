#!/bin/bash

# Define command_exists function
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if jq is installed
if ! command_exists jq; then
  echo "jq is not installed. Attempting to install it..."
  sudo apt-get update
  if sudo apt-get install -y jq; then
    echo "jq has been successfully installed."
  else
    echo "Error: Failed to install jq. Please install it manually (e.g., 'sudo apt-get install jq')."
    exit 1
  fi
fi

# Load the JSON data
json_data=$(cat secrets.json)

# Parse the JSON and set environment variables
while IFS='=' read -r key value; do
  export "$key"="$value"

  # Check if the export is already in .bashrc (improved check)
  if ! grep -q "export $key="$value"" "$HOME/.bashrc"; then
    # Add the export to .bashrc (using $HOME/.bashrc for consistency)
    echo "export $key="$value"" >> "$HOME/.bashrc"
    echo "Added export for $key to $HOME/.bashrc"
  fi
done < <(jq -r '. | keys[] as $k | "\($k)=\(\.[$k])"' <<< "$json_data")

# Source .bashrc to apply the changes immediately (if new exports were added)
if [[ $(grep -q "export " "$HOME/.bashrc") ]]; then
  source "$HOME/.bashrc"
  echo "Sourced $HOME/.bashrc to apply changes."
fi


# Verify the environment variables (optional)
echo "GOOSE_PROVIDER: $GOOSE_PROVIDER"
echo "GOOSE_MODEL: $GOOSE_MODEL"
echo "GOOGLE_API_KEY: $GOOGLE_API_KEY"

# Set the path before calling goose
export PATH="$HOME/.local/bin:$PATH"

# Now you can run your goose commands
goose session
