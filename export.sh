#   Set default blocksize for ls, df, du
#   from this: http://hints.macworld.com/comment.php?mode=view&cid=24491
#   ------------------------------------------------------------
export BLOCKSIZE=1k

#   Set language
#   ------------------------------------------------------------
export LANG=en_US.UTF-8

#   Helper functions
#   ------------------------------------------------------------
function setPath() {
	if [[ -d $1 ]]; then
		export PATH=$PATH:$1
	fi
}

function setLdLibraryPath() {
	if [ -d $1 ]; then
		export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$1
	fi
}

#   Set Paths
#   ------------------------------------------------------------
setPath "/bin"
setPath "/sbin"
setPath "/usr/bin"
setPath "/usr/sbin"
setPath "/usr/local/bin"
setPath "/usr/local/mysql/bin"
setPath "/usr/local/sbin"
setPath "/opt/local/bin"
setPath "/usr/local/git/bin"
setPath "$HOME/bin"
setPath "$HOME/.bin"
# Editor Paths
setPath "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
setPath "/Applications/Xcode.app/Contents/Developer/usr/bin"

setPath "/sw/bin/"

setPath "/usr/local/Cellar/gems/2.0.0/bin"
setPath "/usr/local/Cellar/ruby/2.2.0/bin"
# export GEM_HOME='/usr/local/Cellar/gems/2.0.0'

#   Set Homebrew defaults
#   ------------------------------------------------------------
HOMEBREW_PATH="$HOME/homebrew"
if [[ -d $HOMEBREW_PATH ]]; then
	setPath "$HOMEBREW_PATH/bin"
	setLdLibraryPath "$HOMEBREW_PATH/lib"
fi

#   Set fastlane defaults
#   ------------------------------------------------------------
# User home
FASTLANE_PATH="$HOME/.fastlane"
if [[ -d $FASTLANE_PATH ]]; then
	setPath "$FASTLANE_PATH/bin"
	# we don't want to influence the stats
	export FASTLANE_SKIP_UPDATE_CHECK="1"
	export FASTLANE_OPT_OUT_USAGE="1"
	export FASTLANE_OPT_OUT_CRASH_REPORTING="1"
fi

#   Set maven defaults
#   ------------------------------------------------------------
M2_HOME="/Users/Shared/Development/Tools/apache-maven-3.2.1/"
if [[ -d $M2_HOME ]]; then
	export M2_HOME
	export M2=$M2_HOME/bin
	setPath "$M2"
fi

#   Set rvm defaults
#   ------------------------------------------------------------
RVM_PATH="$HOME/.rvm"
if [[ -d $RVM_PATH ]]; then
	setPath "$RVM_PATH/bin"                                            # Add RVM to PATH for scripting
	[[ -s "$RVM_PATH/scripts/rvm" ]] && source "$RVM_PATH/scripts/rvm" # Load RVM into a shell session *as a function*
fi

#   Set Default Editor (change 'Nano' to the editor of your choice)
#   Preferred editor for local and remote sessions
#   ------------------------------------------------------------
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR=${EDITOR_CLI}
else
	export EDITOR=${EDITOR_UI}
fi