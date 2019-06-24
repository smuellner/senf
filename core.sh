#   Core functions
#   ------------------------------------------------------------
function setPath() {
	if [[ -d $1 ]]; then
		export PATH=$PATH:$1
	fi
}

function setLdLibraryPath() {
	if [ -d $1 ]; then
		export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$1
	fi
}

export EDITOR_CLI='/usr/bin/nano'
export EDITOR_UI='/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'
export GIT_CLI='/usr/bin/git'
export GIT_UI='/Applications/SourceTree.app/Contents/Resources/stree'