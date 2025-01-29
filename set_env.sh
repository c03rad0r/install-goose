#!/bin/bash

# Load the JSON data
json_data=$(cat secrets.json)

# Parse the JSON and set environment variables
while IFS='=' read -r key value; do
  export "$key"="$value"

  # Check if the export is already in .bashrc (improved check)
  if ! grep -q "export $key=\"$value\"" ~/.bashrc; then
    # Add the export to .bashrc (using $HOME/.bashrc for consistency)
    echo "export $key=\"$value\"" >> "$HOME/.bashrc"
    echo "Added export for $key to $HOME/.bashrc"
  fi
done < <(jq -r '. | keys[] as $k | "\($k)=\(.[$k])"' <<< "$json_data")

# Source .bashrc to apply the changes immediately (if new exports were added)

if [[ $(grep -q "export " "$HOME/.bashrc") ]]; then
  source "$HOME/.bashrc"
  echo "Sourced $HOME/.bashrc to apply changes."
fi

# Verify the environment variables (optional)
echo "GOOSE_PROVIDER: $GOOSE_PROVIDER"
echo "GOOSE_MODEL: $GOOSE_MODEL"
echo "GOOGLE_API_KEY: $GOOGLE_API_KEY"

# Check if goose is installed and in PATH
if ! command_exists goose; then
    echo "Error: goose command not found.  Make sure it's installed and in your PATH."
    exit 1
fi

# Now you can run your goose commands
goose session
