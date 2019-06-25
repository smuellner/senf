
#   Log output functions
#   ------------------------------------------------------------
function printHead() {
	echo " === $1 ==="
}

function printInfo() {
	echo " $1"
}


#   Senf functions
#   ------------------------------------------------------------
export SENF_ADDONS=()
export SENF_ERRORS=()
export SENF_INSTALL_ERRORS=()

function addSenf() {
	if [[ -n $1 ]]; then
		SENF_ADDONS+=("$1")
	fi
}

function senfError() {
	if [[ -n $1 ]]; then
		SENF_ERRORS+=("$1")
	fi
}

function senfInstallError() {
	if [[ -n $1 ]]; then
		SENF_INSTALL_ERRORS+=("$1")
	fi
}

function senf() {
	if [ ${#SENF_ADDONS[@]} -gt 0 ]; then
		printHead "ADDONS"
	fi
	for senfAddon in ${SENF_ADDONS[@]}; do
		printInfo "✅ ${senfAddon}"
	done
	if [ ${#SENF_ADDONS[@]} -gt 0 ]; then
		echo ""
	fi

	senfErrorSummary
}

function senfErrorSummary() {
	if [ ${#SENF_ERRORS[@]} -gt 0 ]; then
		printHead "ERRORS"
	fi
	for senfError in ${SENF_ERRORS[@]}; do
		printInfo "❌ ${senfError}"
	done
	if [ ${#SENF_ERRORS[@]} -gt 0 ]; then
		echo ""
	fi

	if [ ${#SENF_INSTALL_ERRORS[@]} -gt 0 ]; then
		printHead "INSTALL ERRORS"
	fi
	for senfInstallError in ${SENF_INSTALL_ERRORS[@]}; do
		printInfo "❌ ${senfInstallError}"
	done
	if [ ${#SENF_INSTALL_ERRORS[@]} -gt 0 ]; then
		printInfo "👟 Run ~/.env/install.sh"
		echo ""
	fi
}

#   Path functions
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

function loadPlugins() {
	for plugin in ${plugins[@]}; do
		pluginPath="$HOME/.env/plugins/${plugin}.sh"
		if [[ -f ${pluginPath} ]]; then
			source ${pluginPath}
		else
			senfError "Plugin '${plugin}' missing at '${pluginPath}'!"
		fi
	done
}

export EDITOR_CLI='/usr/bin/nano'
export EDITOR_UI='/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'
export GIT_CLI='/usr/bin/git'
export GIT_UI='/Applications/SourceTree.app/Contents/Resources/stree'
