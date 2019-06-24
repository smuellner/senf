#   Core functions
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
	for senfAddon in ${SENF_ADDONS[@]}; do
		echo "✅ ${senfAddon}"
	done

	senfErrorSummary
}

function senfErrorSummary() {
	if [ ${#SENF_ERRORS[@]} -gt 0 ]; then
		echo "==> ERRORS" 
	fi
	for senfError in ${SENF_ERRORS[@]}; do
		echo "❌ ${senfError}"
	done

	if [ ${#SENF_INSTALL_ERRORS[@]} -gt 0 ]; then
		echo "==> INSTALL ERRORS" 
	fi
	for senfInstallError in ${SENF_INSTALL_ERRORS[@]}; do
		echo "❌ ${senfInstallError}"
	done
	if [ ${#SENF_INSTALL_ERRORS[@]} -gt 0 ]; then
		echo "👟 Run ~/.env/install.sh"
	fi
}

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