#!/usr/bin/env bash
set -eu

senf_path="${SENF_PATH:-${HOME}/.senf}"
backup_path="${senf_path}.uninstalled.$(date +%Y%m%d%H%M%S)"

if [[ ! -d "$senf_path" ]]; then
	printf 'senf is not installed at %s\n' "$senf_path"
	exit 0
fi

mv "$senf_path" "$backup_path"
printf 'Moved senf to %s\n' "$backup_path"
printf 'Remove the senf source lines from ~/.zshrc or ~/.bashrc when ready.\n'
