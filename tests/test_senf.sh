#!/usr/bin/env bash
set -eu

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export HOME="${TMPDIR:-/tmp}/senf-test-home"
export SENF_PATH="$repo_root"
mkdir -p "$HOME"
plugins=()
senf_plugins=()
source "$repo_root/initialize.sh"

[[ "$SENF_ARCH_NAME" != "" ]]
[[ "$SENF_OS_NAME" != "" ]]
[[ "$SENF_PLUGIN_API_VERSION" == 1 ]]
[[ "${#SENF_LOADED_PLUGINS[@]}" -eq 0 ]]

path_before="$PATH"
setPath /usr/bin
[[ "$PATH" == "$path_before" ]]

senfRegisterPlugin does-not-exist >/dev/null 2>&1 && exit 1 || true
output="$(senf path)"
[[ "$output" == *"/usr/bin"* ]]

senfRegisterPlugin proxy
[[ "${#SENF_LOADED_PLUGINS[@]}" -eq 0 ]]
senf_plugin_load proxy
[[ "${SENF_LOADED_PLUGINS[0]}" == proxy ]]

plugins=(powerline-shell)
SENF_PENDING_PLUGINS=()
SENF_LOADED_PLUGINS=()
senfRegisterPlugin powerline-shell
senfLazyInit || true
type powerline_precmd >/dev/null 2>&1 || true

printf 'All senf tests passed.\n'
