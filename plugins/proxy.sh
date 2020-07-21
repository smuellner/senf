#!/bin/sh

export ZSCALER_URL="http://localhost:9000/localproxy.pac"
export ZSCALER_PATH="/Applications/Zscaler"
export ZSCALER_RUNTIME="${ZSCALER_PATH}/Zscaler.app/MacOS/Zscaler"

function setNoProxy() {
	unset http_proxy
	unset https_proxy
}

function setZScalerProxy() {
	export http_proxy="${ZSCALER_URL}"
	export https_proxy="${ZSCALER_URL}"
	addSenfEnv "http_proxy" "${ZSCALER_URL}"
	addSenfEnv "https_proxy" "${ZSCALER_URL}"
}

function showProxy() {
	printHead "PROXY SETTINGS"
	echo "http_proxy  : ${http_proxy}"
	echo "https_proxy : ${https_proxy}"
	echo "no_proxy    : ${no_proxy}"
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
