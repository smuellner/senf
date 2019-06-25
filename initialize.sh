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

senf_path=$(cd `dirname $0` && pwd)

#   -------------------------------
#   1.  CORE
#   -------------------------------
source ${senf_path}/core/core.sh


#   -------------------------------
#   2.  EXPORTS
#   -------------------------------
source ${senf_path}/core/exports.sh


#   -------------------------------
#   3.  ALIASES
#   -------------------------------
source ${senf_path}/core/alias.sh


#   -------------------------------
#   4.  GENERAL FUNCTIONS
#   -------------------------------
source ${senf_path}/core/functions.sh


#   -------------------------------
#   6.  LOAD PLUGINS
#   -------------------------------
loadPlugins

#   -------------------------------
#   5.  ERROR SUMMARY
#   -------------------------------
senfErrorSummary