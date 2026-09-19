#!/bin/sh

set -u

###
# Environement
SENF_PATH="${HOME}/.senf"
SENF_BIN_PATH="${HOME}/.senf/bin"
mkdir -p "${SENF_BIN_PATH}/"

if ! command -v git >/dev/null 2>&1 || ! command -v curl >/dev/null 2>&1; then
	echo "❌ senf requires git and curl" >&2
	exit 1
fi

###
# Update Installation
cd "${SENF_PATH}"
git pull --ff-only

###
# powerline-shell
powerline_os=$(uname | tr '[:upper:]' '[:lower:]')
powerline_arch=$(uname -m | tr '[:upper:]' '[:lower:]')
case "${powerline_os}:${powerline_arch}" in
  linux*:x86_64|linux*:amd64)
    powerline_cmd="powerline-go-linux-amd64"
    ;;
  linux*:aarch64|linux*:arm64)
    powerline_cmd="powerline-go-linux-arm64"
    ;;
  darwin*:x86_64|darwin*:amd64)
    powerline_cmd="powerline-go-darwin-amd64"
    ;;
  darwin*:arm64|darwin*:aarch64)
    powerline_cmd="powerline-go-darwin-arm64"
    ;;
  msys*:x86_64|mingw*:x86_64)
    powerline_cmd="powerline-go-windows-amd64.exe"
    ;;
  msys*:arm64|mingw*:arm64)
    powerline_cmd="powerline-go-windows-arm64.exe"
    ;;
esac

if [ -n "${powerline_cmd:-}" ]; then
	powerline_shell="${SENF_PATH}/bin/${powerline_cmd}"
	if test -e "${powerline_shell}"; then
		echo "✅ ${powerline_shell} already installed"
	else
		echo "⚙️  Installing powerline-shell"
		echo "${powerline_shell}"
		curl --fail --location --silent --show-error \
			"https://github.com/justjanne/powerline-go/releases/latest/download/${powerline_cmd}" \
			--output "${powerline_shell}"
		chmod 755 "${powerline_shell}"
	fi
fi

###
# powerline fonts
fonts_tmp=$(mktemp -d "${TMPDIR:-/tmp}/senf-fonts.XXXXXX")
trap 'rm -rf "${fonts_tmp}"' EXIT
git clone https://github.com/powerline/fonts.git --depth=1 "${fonts_tmp}/fonts"
"${fonts_tmp}/fonts/install.sh"

###
# bash
bashrc="${HOME}/.bashrc"
senf_bashrc="\${HOME}/.senf/bashrc"

! test -e "${bashrc}" && touch "${bashrc}"

if test -e "${bashrc}"; then
	if grep -q "${senf_bashrc}" "${bashrc}"; then
		echo "✅ ${senf_bashrc} already sourced"
	else
		echo "⚙️  Sourcing ${senf_bashrc}"
		echo "" >>${bashrc}
		echo "# Including senf_bashrc" >>${bashrc}
		echo "test -e \"${senf_bashrc}\" && source \"${senf_bashrc}\"" >>${bashrc}
	fi
else
	echo "❌ ${senf_bashrc} does not exist"
fi

###
# zsh
zshrc=${HOME}/.zshrc
senf_zshrrc="\${HOME}/.senf/zshrc"

! test -e "${zshrc}" && touch "${zshrc}"

if test -e "${zshrc}"; then
	if grep -q "${senf_zshrrc}" "${zshrc}"; then
		echo "✅ ${senf_zshrrc} already sourced"
	else
		echo "⚙️  Sourcing ${senf_zshrrc}"
		echo "" >>${zshrc}
		echo "# Including env zshrc" >>${zshrc}
		echo "test -e \"${senf_zshrrc}\" && source \"${senf_zshrrc}\"" >>${zshrc}
	fi
else
	echo "❌ ${zshrc} does not exist"
fi

###
# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
