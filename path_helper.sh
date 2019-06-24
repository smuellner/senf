if [ -f "/usr/libexec/path_helper" ]; then
	eval $(/usr/libexec/path_helper -s)
	addSenf "path_helper"
else
	senfInstallError "Missing path_helper install."
fi
