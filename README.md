<div align="center">

<img src="assets/senf-logo.svg" alt="senf logo" width="120" />

# senf

### A fast, reliable shell helper for Bash and Zsh

<p>Lazy plugins · Powerline prompts · Safe updates · Built-in diagnostics</p>

</div>

## Why senf?

senf is a small, practical shell toolkit for people who want a better terminal
without maintaining a giant configuration framework. It keeps initialization
quiet and fast, loads optional integrations on demand, and gives every plugin a
consistent API.

## Features

- Fast Bash and Zsh initialization with duplicate-safe PATH handling.
- Lazy plugin loading for Powerline, Oh My Zsh, proxy helpers, and user plugins.
- First-class Apple Silicon, Intel macOS, Linux, and Windows Powerline support.
- A discoverable command interface with `senf doctor` diagnostics.
- Safe update and reinstall flows that preserve backups.
- Explicit plugin states: pending, loaded, or failed.
- Bash and Zsh completions.
- No automatic network calls during shell startup.

## Install

```bash
git clone https://github.com/smuellner/senf "$HOME/.senf"
"$HOME/.senf/install.sh"
exec "$SHELL"
```

The installer downloads the matching Powerline binary and adds senf to your
Bash or Zsh startup file. Powerline fonts are installed separately by the
installer when needed.

## Everyday commands

```bash
senf doctor                 # Check the installation
senf plugins                # Show registered and loaded plugins
senf plugin load proxy      # Load one plugin now
senf path                   # Print PATH entries clearly
senf reload                 # Show the reload command
senf update                 # Fast-forward and reinstall
senf reinstall              # Replace safely, preserving a backup
senf help                   # Open the full command reference
```

Useful helpers include:

```bash
setjdk 21
proxy on
proxy off
proxy status
up
mcd new-project
```

## Plugin API

Place personal plugins in `~/.senf_plugins/<name>.sh`, then add their names to
`senf_plugins` in your shell configuration.

```bash
#!/usr/bin/env bash

addSenf "example"

example() {
  printf 'Loaded from %s\n' "$SENF_PLUGIN_DIR"
}
```

Plugins receive:

| Variable | Meaning |
|---|---|
| `SENF_PLUGIN_NAME` | Current plugin name |
| `SENF_PLUGIN_DIR` | Directory containing the plugin |
| `SENF_PLUGIN_API_VERSION` | Plugin API version, currently `1` |

Plugins can use `addSenf`, `addSenfEnv`, `senf_plugin_register`, and
`senf_plugin_load`. Plugin files should avoid network calls and destructive
work at load time.

## Configuration

In `~/.zshrc` or `~/.bashrc`:

```bash
plugins=(oh-my-zsh powerline-shell path_helper proxy)
senf_plugins=(docker kubectl)
source "$HOME/.senf/initialize.sh"
```

Set `SENF_SHOW_SUMMARY=1` when you want a startup summary. Use
`SENF_SKIP_USER_PROFILE=1` for isolated scripts and automation.

## Development

Run the built-in checks from the repository root:

```bash
bash tests/test_senf.sh
bash -n core/*.sh plugins/*.sh initialize.sh
zsh -n core/*.sh plugins/*.sh initialize.sh zshrc
```

The project is intentionally dependency-light. ShellCheck, shfmt, and Bats are
recommended for local development when available.

## License

senf is released under the GNU General Public License. See [LICENSE](LICENSE).
