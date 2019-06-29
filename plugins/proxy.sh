export ZSCALER_URL="http://localhost:9000/localproxy.pac"x
export ZSCALER_PATH="/Applications/Zscaler"
export ZSCALER_RUNTIME="${ZSCALER_PATH}/Zscaler.app/MacOS/Zscaler"

function setNoProxy() {
	unset HTTP_PROXY
	unset HTTPS_PROXY
}

function setZScalerProxy() {
	export HTTP_PROXY="${ZSCALER_URL}"
	export HTTPS_PROXY="${ZSCALER_URL}"
	addSenfEnv "HTTP_PROXY" "${ZSCALER_URL}"
	addSenfEnv "HTTPS_PROXY" "${ZSCALER_URL}"
}

function showProxy() {
	printHead "PROXY SETTINGS"
	echo "HTTP_PROXY  : ${HTTP_PROXY}"
	echo "HTTPS_PROXY : ${HTTPS_PROXY}"
	echo "NO_PROXY    : ${NO_PROXY}"
}

function autoDetectZscaler() {
	if [[ -d "${ZSCALER_PATH}" ]]; then
		if [[ -x "${ZSCALER_RUNTIME}" ]]; then
			addSenfEnv "Zscaler" "${ZSCALER_PATH}"
		fi
	fi
	getHttpCode "${ZSCALER_URL}"
	if [[ "${http_code}" == "200" ]]; then
		setZScalerProxy
	fi
}

autoDetectZscaler

addSenf "proxy"
