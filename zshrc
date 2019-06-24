#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my ZSH configurations and aliases
#
#  Sections:
#  1.   Core functions 
#  2.   Exports
#  3.   Aliases 
#  4.   General and often used functions
#  5.   Set Base JDK
#  6.   Including powerline shell
#  7.   Including path_helper
#  8.   Including oh-my-zsh
#  9.   Errors
#
#  ---------------------------------------------------------------------------

#   -------------------------------
#   1.  CORE
#   -------------------------------
source ~/.env/core.sh


#   -------------------------------
#   2.  EXPORTS
#   -------------------------------
source ~/.env/export.sh


#   -------------------------------
#   3.  ALIASES
#   -------------------------------
source ~/.env/alias.sh


#   -------------------------------
#   4.  GENERAL FUNCTIONS
#   -------------------------------
source ~/.env/functions.sh


#   -------------------------------
#   5.  BASE JDK
#   -------------------------------
setjdk 1.8


#   -------------------------------
#   6.  INCLUDING POWERLINE SHELL
#   -------------------------------
source ~/.env/powerline-shell.sh


#   -------------------------------
#   7.  INCLUDING PATH_HELPER
#   -------------------------------
source ~/.env/path_helper.sh


#   -------------------------------
#   8.  INCLUDING OH-MY-ZSH
#   -------------------------------
source ~/.env/oh-my-zsh.sh


#   -------------------------------
#   9.  ERROR SUMMARY
#   -------------------------------
senfErrorSummary