#  ---------------------------------------------------------------------------
#
#  Description:  This file initalizes the senf env.
#
#  Sections:
#  1.   Core functions 
#  2.   Exports
#  3.   Aliases 
#  4.   General and often used functions
#  5.   Load plugins
#  6.   Show error summary
# 
#  ---------------------------------------------------------------------------
SENF_PATH="${HOME}/.senf"

#   -------------------------------
#   1.  CORE
#   -------------------------------
source ${SENF_PATH}/core/core.sh


#   -------------------------------
#   2.  EXPORTS
#   -------------------------------
source ${SENF_PATH}/core/exports.sh


#   -------------------------------
#   3.  ALIASES
#   -------------------------------
source ${SENF_PATH}/core/alias.sh


#   -------------------------------
#   4.  GENERAL FUNCTIONS
#   -------------------------------
source ${SENF_PATH}/core/functions.sh


#   -------------------------------
#   6.  LOAD PLUGINS
#   -------------------------------
loadPlugins

#   -------------------------------
#   5.  ERROR SUMMARY
#   -------------------------------
senfErrorSummary