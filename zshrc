

eval $(/usr/libexec/path_helper -s)

# bundle
alias bundle!="bundle install && rake install"
alias be="bundle exec"
alias bi="bundle install"
alias bu="bundle update"
alias ri="rake install"

# Git
alias gc="git checkout"
alias gco="git checkout"
alias gcm="git checkout master"
alias gpull="git pull"
alias gpush="git push"
alias gbranch="git checkout -b"
alias gclone="git clone"
alias g="gittower ."
alias gupdate_submodules='git pull --recurse-submodules && git submodule update' 

alias o="open ."

# Compress pngs
alias compress_png="pngquant"
alias png="pngquant"

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
# eval `dircolors`
export LS_OPTIONS='-G'
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -liAT'
alias l='ls $LS_OPTIONS -liAT'
alias dir='ls $LS_OPTIONS -liAT'

alias joe='pico'
alias purge='sudo find . -name ".DS_Store" -depth -exec rm {} \;'

# Maven
alias mvn.clean='mvn clean install -U'
alias mvn.deploy='mvn deploy'
alias mvn.package='mvn clean; mvn package'

alias X11='/opt/X11/bin/XQuartz &'
alias SDUnmounter='sudo kextunload /System/Library/Extensions/AppleStorageDrivers.kext/Contents/PlugIns/AppleUSBCardReader.kext'
alias SDRemounter='sudo kextunload /System/Library/Extensions/AppleStorageDrivers.kext/Contents/PlugIns/AppleUSBCardReader.kext; sudo kextload /System/Library/Extensions/AppleStorageDrivers.kext/Contents/PlugIns/AppleUSBCardReader.kext'

function o() {
  z $1 && open .
}

function e() {
  _z $1
  git pull
  gittower .
  subl .
}

export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH="$HOME/.fastlane/bin:$PATH"
export PATH=$HOME/bin:$PATH
export PATH=$HOME/homebrew/bin:$PATH
export LD_LIBRARY_PATH=$HOME/homebrew/lib:$LD_LIBRARY_PATH

# we don't want to influence the stats
export FASTLANE_SKIP_UPDATE_CHECK="1"
export FASTLANE_OPT_OUT_USAGE="1"
export FASTLANE_OPT_OUT_CRASH_REPORTING="1"

export LANG=en_US.UTF-8

# Xcode via @orta
openx(){ 
  if test -n "$(find . -maxdepth 1 -name '*.xcworkspace' -print -quit)"
  then
    echo "Opening workspace"
    open *.xcworkspace
    return
  else
    if test -n "$(find . -maxdepth 1 -name '*.xcodeproj' -print -quit)"
    then
      echo "Opening project"
      open *.xcodeproj
      return  
    else
      echo "Nothing found"
    fi
  fi
}


###
# JDK
function setjdk() {
  if [ $# -ne 0 ]; then
   removeFromPath '/System/Library/Frameworks/JavaVM.framework/Home/bin'
   if [ -n "${JAVA_HOME+x}" ]; then
    removeFromPath $JAVA_HOME
   fi
   export JAVA_HOME=`/usr/libexec/java_home -v $@`
   export PATH=$JAVA_HOME/bin:$PATH
  fi
 }
 
 function removeFromPath() {
  export PATH=$(echo $PATH | sed -E -e "s;:$1;;" -e "s;$1:?;;")
 }
setjdk 1.8


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='subl'
fi

# Go to the root of the current git project, or just go one folder up
function up() {
  export git_dir="$(git rev-parse --show-toplevel 2> /dev/null)"
  if [ -z $git_dir ]
  then
    cd ..
  else
    cd $git_dir
  fi
}


# oh-my-zsh 
if [ -d "$HOME/.oh-my-zsh" ]; then
	# Path to your oh-my-zsh installation.
	export ZSH=$HOME/.oh-my-zsh
	
	# Set name of the theme to load.
	# Look in ~/.oh-my-zsh/themes/
	# Optionally, if you set this to "random", it'll load a random theme each
	# time that oh-my-zsh is loaded.
	ZSH_THEME="agnoster"

else
	echo "❓ Missing oh-my-zsh install."
	echo "-> Run ~/.env/install.sh"
fi

if [ -f "/usr/local/bin/powerline-shell" ]; then

	# Powerline
	function powerline_precmd() {
		PS1="$(/usr/local/bin/powerline-shell --shell zsh $?)"
	}
	
	function install_powerline_precmd() {
	  for s in "${precmd_functions[@]}"; do
		if [ "$s" = "powerline_precmd" ]; then
		  return
		fi
	  done
	  precmd_functions+=(powerline_precmd)
	}
	
	if [ "$TERM" != "linux" ]; then
		install_powerline_precmd
	fi
else
	echo "❓ Missing powerline install."
	echo "🖥 Run ~/.env/install.sh"
fi
