 #!/bin/sh

###
# pip && powerline-shell
pip3=$(which pip3)
pip=$(which pip)

if [[ -x "${pip3}" ]]; then
	$pip3 install --upgrade pip
	$pip3 install powerline-shell
elif [[ -x "${pip}" ]]; then
	$pip install --upgrade pip
	$pip install powerline-shell
fi
 
###
# bash
bashrc="${HOME}/.bashrc"
env_bashrc="\${HOME}/.env/bashrc"

if test -f "${bashrc}"; then
    if grep -q "${env_bashrc}" "${bashrc}"; then
    	echo "✅ ${env_bashrc} already sourced"
    else
    	echo "✅ Sourcing ${env_bashrc}"
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
    	echo "✅ Sourcing ${env_zshrrc}"
    	echo "" >> ${zshrc}
    	echo "# Including env zshrc" >> ${zshrc}
    	echo "test -e \"${env_zshrrc}\" && source \"${env_zshrrc}\"" >> ${zshrc}
	fi
else	
    echo "❌ ${zshrc} does not exist"
fi


sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"