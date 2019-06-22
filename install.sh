 #!/bin/sh

pip3=$(which pip3)
pip=$(which pip)

if [[ -x "$pip3" ]]; then
	$pip3 install --upgrade pip
	$pip3 install powerline-shell
elif [[ -x "$pip" ]]; then
	$pip install --upgrade pip
	$pip install powerline-shell
fi
 

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"