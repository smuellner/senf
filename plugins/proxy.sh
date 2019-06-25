
function setNoProxy() {
	unset HTTP_PROXY
	unset HTTPS_PROXY
}

function setZScalerProxy() {
    export HTTP_PROXY="http://localhost:9000/localproxy.pac"
    export HTTPS_PROXY="http://localhost:9000/localproxy.pac"
}

function showProxy() {
    printHead "PROXY SETTINGS"
	echo "HTTP_PROXY  : $HTTP_PROXY"
	echo "HTTPS_PROXY : $HTTPS_PROXY"
	echo "NO_PROXY    : $NO_PROXY"
}

addSenf "proxy"