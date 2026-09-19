#!/usr/bin/env bash

# User-facing command surface. This file is sourced by initialize.sh.

function senfPath() {
	printf '%s\n' "$PATH" | command tr ':' '\n'
}

function senfPlugins() {
	local plugin
	printf 'Registered plugins:\n'
	for plugin in "${SENF_PENDING_PLUGINS[@]}"; do
		local state=' (pending)'
		if senfPluginIsLoaded "$plugin"; then
			state=' (loaded)'
		else
			for failed in "${SENF_FAILED_PLUGINS[@]}"; do
				[[ "$failed" == "$plugin" ]] && state=' (failed)'
			done
		fi
		printf '  %s%s\n' "$plugin" "$state"
	done
}

function senfPluginCommand() {
	local action="${1:-list}"
	local plugin="${2:-}"
	case "$action" in
		list) senfPlugins ;;
		load)
			[[ -n "$plugin" ]] || { printf 'Usage: senf plugin load NAME\n' >&2; return 2; }
			senfRegisterPlugin "$plugin" && senfLoadPlugin "$plugin"
			;;
		*) printf 'Usage: senf plugin {list|load NAME}\n' >&2; return 2 ;;
	esac
}

function senfPluginIsLoaded() {
	local plugin="$1"
	local loaded
	for loaded in "${SENF_LOADED_PLUGINS[@]}"; do
		[[ "$loaded" == "$plugin" ]] && return 0
	done
	return 1
}

function senfDoctor() {
	local failures=0
	local item
	local plugin_path
	local start_ns
	local end_ns
	local elapsed_ms

	printf 'senf doctor\n\n'
	printf 'Environment\n'
	printf '  shell: %s\n' "${SHELL:-unknown}"
	printf '  os: %s\n' "${SENF_OS_NAME:-unknown}"
	printf '  arch: %s\n' "${SENF_ARCH_NAME:-unknown}"
	printf '  path: %s\n' "${SENF_PATH:-unknown}"

	printf '\nRequired commands\n'
	for item in git curl; do
		if command -v "$item" >/dev/null 2>&1; then
			printf '  ✓ %s\n' "$item"
		else
			printf '  ✗ %s (missing)\n' "$item"
			failures=$((failures + 1))
		fi
	done

	printf '\nPlugin files\n'
	for item in "${SENF_PENDING_PLUGINS[@]}"; do
		plugin_path="${SENF_PLUGINS_PATH}/${item}.sh"
		[[ -f "$plugin_path" ]] || plugin_path="${SENF_USER_PLUGINS_PATH}/${item}.sh"
		if [[ -f "$plugin_path" ]]; then
			printf '  ✓ %s\n' "$item"
		else
			printf '  ✗ %s (%s)\n' "$item" "$plugin_path"
			failures=$((failures + 1))
		fi
	done

	printf '\nPATH\n'
	while IFS= read -r item; do
		[[ -z "$item" ]] && continue
		if [[ ! -d "$item" ]]; then
			printf '  ! missing directory: %s\n' "$item"
		fi
	done < <(senfPath)

	if [[ -n "${EPOCHREALTIME:-}" ]]; then
		start_ns="${EPOCHREALTIME/./}"
	else
		start_ns="$(date +%s%N 2>/dev/null || date +%s000000000)"
	fi
	true
	if [[ -n "${EPOCHREALTIME:-}" ]]; then
		end_ns="${EPOCHREALTIME/./}"
	else
		end_ns="$(date +%s%N 2>/dev/null || date +%s000000000)"
	fi
	elapsed_ms=$(( (end_ns - start_ns) / 1000000 ))
	printf '\nStartup probe: %sms\n' "$elapsed_ms"

	if (( failures == 0 )); then
		printf '\n✓ senf looks healthy\n'
	else
		printf '\n✗ %s issue(s) found\n' "$failures"
	fi
	return "$failures"
}

function senfReload() {
	printf 'Reload the current shell with:\n  source "%s/initialize.sh"\n' "$SENF_PATH"
}

function senf() {
	case "${1:-help}" in
		doctor) shift; senfDoctor "$@" ;;
		update) shift; senfUpdate "$@" ;;
		reinstall) shift; senfReinstall "$@" ;;
		plugins) shift; senfPlugins "$@" ;;
		plugin) shift; senfPluginCommand "$@" ;;
		path) shift; senfPath "$@" ;;
		reload) shift; senfReload "$@" ;;
		help|-h|--help) senfHelp "$@" ;;
		*) printf 'Unknown senf command: %s\n' "$1" >&2; senfHelp; return 2 ;;
	esac
}

function proxy() {
	senfLoadPlugin proxy || return
	case "${1:-status}" in
		on) setZScalerProxy ;;
		off) setNoProxy ;;
		status) showProxy ;;
		*) printf 'Usage: proxy {on|off|status}\n' >&2; return 2 ;;
	esac
}
