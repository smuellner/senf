 #!/bin/sh

###
# python, pip
python --version
python -m ensurepip --default-pip --upgrade --user
python -m pip install --upgrade pip setuptools wheel --user

pip install --upgrade pip --user
	
###
# powerline-shell

powerline_shell="/usr/local/bin/powerline-shell"

if [ ! -f ${powerline_shell} ]; then
	powerline_shell=$(find ~/Library/Python/*/bin -name powerline-shell -print | head -n 1)
fi

if test -f ${powerline_shell}; then
    echo "✅ ${powerline_shell} already installed"
else
    echo "⚙️  Installing powerline-shell"
    echo ${powerline_shell}
    pip install powerline-shell --user
fi

###
# powerline fonts
cd ~Downloads
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
env_bashrc="\${HOME}/.env/bashrc"

if test -f "${bashrc}"; then
    if grep -q "${env_bashrc}" "${bashrc}"; then
    	echo "✅ ${env_bashrc} already sourced"
    else
    	echo "⚙️  Sourcing ${env_bashrc}"
    	echo "" >> ${bashrc}
    	echo "# Including env_bashrc" >> ${bashrc}
    	echo "test -e \"${env_bashrc}\" && source \"${env_bashrc}\"" >> ${bashrc}
	fi
else	
    echo "❌ ${env_bashrc} does not exist"
fi

###
# zsh
zshrc=${HOME}/.zshrc
env_zshrrc="\${HOME}/.env/zshrc"

if test -f "${zshrc}"; then
    if grep -q "${env_zshrrc}" "${zshrc}"; then
    	echo "✅ ${env_zshrrc} already sourced"
    else
    	echo "⚙️  Sourcing ${env_zshrrc}"
    	echo "" >> ${zshrc}
    	echo "# Including env zshrc" >> ${zshrc}
    	echo "test -e \"${env_zshrrc}\" && source \"${env_zshrrc}\"" >> ${zshrc}
	fi
else	
    echo "❌ ${zshrc} does not exist"
fi


###
# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"