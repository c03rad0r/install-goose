```markdown
# Instructions to install goose

https://block.github.io/goose/docs/getting-started/installation/

# Scripts to install goose

```bash
./build_openssl.sh
./install_goose.sh
```

# Configuration and Usage

Goose requires a configuration file named `secrets.json` in the same directory where you run the Goose commands. This file should contain your API keys and other settings in JSON format. A sample `secrets.json` file is provided below. **Replace `"your_actual_api_key"` with your actual Google Gemini API key.**

```json
{
  "GOOSE_PROVIDER": "google",
  "GOOSE_MODEL": "gemini-2.0-flash-exp",
  "GOOGLE_API_KEY": "your_actual_api_key"
}
```

## Setting Environment Variables and Running Goose

1. **Create `secrets.json`:** Create the `secrets.json` file with your API key.  Make sure it is valid JSON.  Use a JSON validator if you are unsure.

2. **Make `set_env.sh` executable:**

```bash
chmod +x set_env.sh
```

3. **Run `set_env.sh`:** Before running any `goose` commands, execute the `set_env.sh` script:

```bash
./set_env.sh
```

This will load the settings from `secrets.json`, set the environment variables, add them to your `.bashrc` file, and start a Goose session.  If `goose` is not found, it will attempt to add it to the PATH.  If it still cannot be found, double check your goose installation.

**Troubleshooting:**

* **`jq` not found:** Run `sudo apt-get install jq` (or the equivalent for your distribution).
* **`secrets.json` errors:** Carefully check your `secrets.json` file for syntax errors (commas, quotes, etc.). Use a JSON validator.
* **`goose` not found:** Ensure that you have installed Goose correctly. The installation process should place the `goose` executable in your PATH.  If it is not in `$HOME/.local/bin` try `/usr/local/bin` or wherever your installation process placed it.  Check the output of your `install_goose.sh` script.  If you're using a different shell (zsh, fish, etc.), make sure to update the `.bashrc` references to the correct configuration file (e.g., `.zshrc`, `.config/fish/config.fish`).
* **Input error: EOF:** This error usually means that the Goose session is not receiving any input.  Make sure your terminal is properly connected and that you are typing commands after the `( O)>` prompt. If it happens immediately, the Goose session might be crashing.  Check the Goose logs (the path is given in the output) for any error messages.

