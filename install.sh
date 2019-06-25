#!/bin/sh

senf_path=$(cd `dirname $0` && pwd)

###
# python, pip
python_cmd=$(which python)
${python_cmd} --version
${python_cmd} -m ensurepip --default-pip --upgrade --user
${python_cmd} -m pip install --upgrade pip setuptools wheel --user

python_bin_path="${HOME}/Library/Python/*/bin"
pip_cmd="${python_bin_path}/pip"
${pip_cmd} --version
${pip_cmd} install --upgrade pip --user

###
# powerline-shell

powerline_shell="/usr/local/bin/powerline-shell"

if [ ! -f ${powerline_shell} ]; then
	powerline_shell=$(find ${python_bin_path} -name powerline-shell -print | head -n 1)
fi

if test -f ${powerline_shell}; then
	echo "✅ ${powerline_shell} already installed"
else
	echo "⚙️  Installing powerline-shell"
	echo ${powerline_shell}
	${pip_cmd}  install powerline-shell --user
fi

###
# powerline fonts
cd ~/Downloads
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts
cd

###
# bash
bashrc="${HOME}/.bashrc"
senf_bashrc="${senf_path}/bashrc"

if test -f "${bashrc}"; then
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
senf_zshrrc="${senf_path}/zshrc"

if test -f "${zshrc}"; then
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
