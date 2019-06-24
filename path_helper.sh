if [ -f "/usr/libexec/path_helper" ]; then
	echo "✅ path_helper"
	eval $(/usr/libexec/path_helper -s)
else
	echo "❓ Missing path_helper install."
	echo "👟 Run ~/.env/install.sh"
fi
