#!/bin/sh

#  ---------------------------------------------------------------------------
#
#  Description:  This file initalizes the senf env.
#
#  Sections:
#  1.   Core functions 
#  2.   Exports
#  3.   Aliases 
#  4.   General and often used functions
#  5.   Loaud user profile
#  6.   Load plugins
#  7.   Show error summary
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
#   5.  Source user profile
#   -------------------------------
test -e ${HOME}/.senf_profile && source ${HOME}/.senf_profile

#   -------------------------------
#   6.  LOAD PLUGINS
#   -------------------------------
loadPlugins
loadUserPlugins

#   -------------------------------
#   7.  ERROR SUMMARY
#   -------------------------------
senfErrorSummary