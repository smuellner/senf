#!/bin/sh

# bundle
alias bundle!="bundle install && rake install"
alias be="bundle exec"
alias bi="bundle install"
alias bu="bundle update"
alias ri="rake install"

# Git
alias gc="git checkout"
alias gco="git checkout origin"
alias gcm="git checkout master"
alias gpull="git pull"
alias gpush="git push"
alias gbranch="git checkout -b"
alias gclone="git clone"
alias gui="${GIT_UI} ."
alias gsub='git pull --recurse-submodules && git submodule update'

# Compress pngs
alias compresspng="pngquant"

# list

# Make `ls'colorized:
export LS_OPTIONS='-G' # Preferred 'ls' implementation
alias ls='ls $LS_OPTIONS'
alias l='ls $LS_OPTIONS -FlAhp'
alias ll='ls $LS_OPTIONS -liAT'
alias dir='ls $LS_OPTIONS'

# Editor
alias joe='pico'

# Maven
alias mvn.clean='mvn clean install -U'
alias mvn.deploy='mvn deploy'
alias mvn.package='mvn clean; mvn package'

alias jdks='/usr/libexec/java_home -V'

alias purge='sudo find . -name ".DS_Store" -depth -exec rm {} \;'
alias X11='/opt/X11/bin/XQuartz &'

alias cp='cp -iv'                          # Preferred 'cp' implementation
alias mv='mv -iv'                          # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                    # Preferred 'mkdir' implementation
alias less='less -FSRXc'                   # Preferred 'less' implementation
alias cd..='cd ../'                        # Go back 1 directory level (for fast typers)
alias ..='cd ../'                          # Go back 1 directory level
alias ...='cd ../../'                      # Go back 2 directory levels
alias .3='cd ../../../'                    # Go back 3 directory levels
alias .4='cd ../../../../'                 # Go back 4 directory levels
alias .5='cd ../../../../../'              # Go back 5 directory levels
alias .6='cd ../../../../../../'           # Go back 6 directory levels
alias edit='subl'                          # edit:         Opens any file in sublime editor
alias f='open -a Finder ./'                # f:            Opens current directory in MacOS Finder
alias ~="cd ~"                             # ~:            Go Home
alias c='clear'                            # c:            Clear terminal display
# alias which='type -all'                     # which:        Find executables
alias path='echo -e ${PATH//:/\\n} | sort' # path:         Echo all executable Paths
alias show_options='shopt'                 # Show_options: display bash options settings
alias fix_stty='stty sane'                 # fix_stty:     Restore terminal settings when screwed up
alias cic='set completion-ignore-case On'  # cic:          Make tab-completion case-insensitive
alias DT='tee ~/Desktop/terminalOut.txt'   # DT:           Pipe content to file on MacOS Desktop

alias numFiles='echo $(ls -1 | wc -l)' # numFiles:     Count of non-hidden files in current dir
alias make1mb='mkfile 1m ./1MB.dat'    # make1mb:      Creates a file of 1mb size (all zeros)
alias make5mb='mkfile 5m ./5MB.dat'    # make5mb:      Creates a file of 5mb size (all zeros)
alias make10mb='mkfile 10m ./10MB.dat' # make10mb:     Creates a file of 10mb size (all zeros)

#   lr:  Full Recursive Directory Listing
#   ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'
