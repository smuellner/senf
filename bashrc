#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my BASH configurations and aliases
#
#  Sections:
#  1.   Inlcude plugins
#  2.   Initialize senf env
#  3.   Set Base JDK
#
#  ---------------------------------------------------------------------------

#   -------------------------------
#   1.  INCLUDE PLUGINS
#   -------------------------------
plugins=(
	powerline-shell
	path_helper
	proxy
)


#   -------------------------------
#   2.  INITIALIZE SENF ENV.
#   -------------------------------
senf_path=$(cd `dirname $0` && pwd)
source ${senf_path}/initialize.sh


#   -------------------------------
#   3.  BASE JDK
#   -------------------------------
setjdk 1.8
