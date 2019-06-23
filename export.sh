export LANG=en_US.UTF-8

export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH="$HOME/.fastlane/bin:$PATH"
export PATH=$HOME/bin:$PATH
export PATH=$HOME/homebrew/bin:$PATH
export LD_LIBRARY_PATH=$HOME/homebrew/lib:$LD_LIBRARY_PATH

#   Set fastlane defaults
#   ------------------------------------------------------------
# we don't want to influence the stats
export FASTLANE_SKIP_UPDATE_CHECK="1"
export FASTLANE_OPT_OUT_USAGE="1"
export FASTLANE_OPT_OUT_CRASH_REPORTING="1"

#   Set Default Editor (change 'Nano' to the editor of your choice)
#   Preferred editor for local and remote sessions
#   ------------------------------------------------------------
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='/usr/bin/nano'
else
  export EDITOR='subl'
fi


#   Set default blocksize for ls, df, du
#   from this: http://hints.macworld.com/comment.php?mode=view&cid=24491
#   ------------------------------------------------------------
# export BLOCKSIZE=1k

#   Set maven defaults
#   ------------------------------------------------------------
export M2_HOME=/Users/Shared/Development/Tools/apache-maven-3.2.1/
export M2=$M2_HOME/bin



#   Set Paths
#   ------------------------------------------------------------
export PATH=/usr/local/Cellar/gems/2.0.0/bin:/usr/local/Cellar/ruby/2.2.0/bin:${PATH}
export PATH=./bin:${HOME}/bin:~/.bin:/Applications/Xcode.app/Contents/Developer/usr/bin:/usr/local/bin:/opt/local/bin:/usr/local/git/bin:~/Entwicklung/bin/apache-maven-3.2.1/bin:${PATH}


#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
# export GEM_HOME='/usr/local/Cellar/gems/2.0.0'

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

    export PATH="$PATH:/usr/local/bin/"
    export PATH="/usr/local/git/bin:/sw/bin/:/usr/local/bin:/usr/local/:/usr/local/sbin:/usr/local/mysql/bin:$PATH"
    

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*