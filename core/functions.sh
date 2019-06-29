#   open folder
#   ------------------------------------------------------------
function o() {
  if [[ -z $1 ]]; then
    _z . && open .
  else
    _z $1 && open .
  fi
}

#   git pull and open in git and text editor
#   ------------------------------------------------------------
function e() {
  local gitRepositoryPath=$1
  if [[ -z $1"${gitRepositoryPath+x}" ]]; then
    _z .
    git pull
    $GIT_UI .
    $EDITOR .
  else
    _z $gitRepositoryPath
    git pull
    $GIT_UI $gitRepositoryPath
    $EDITOR $gitRepositoryPath
  fi
}

#   set jdk you want to use
#   ------------------------------------------------------------
function setjdk() {
  if [ $# -ne 0 ]; then
    removeFromPath '/System/Library/Frameworks/JavaVM.framework/Home/bin'
    if [ -n "${JAVA_HOME+x}" ]; then
      removeFromPath $JAVA_HOME
    fi
    export JAVA_HOME=$(/usr/libexec/java_home -v $@)
    export PATH=$JAVA_HOME/bin:$PATH
  else
    /usr/libexec/java_home -V
    printInfo $JAVA_HOME
  fi
}

function checkjdk() {
  local _javaVersion=$1
  if type -p java; then
    printInfo "✅ Found java executable in PATH"
    _java=java
  elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]]; then
    printInfo "✅ Found java executable in JAVA_HOME"
    _java="$JAVA_HOME/bin/java"
  else
    printError "❌ No java found!"
  fi

  if [[ ! -z "$_javaVersion" && "$_java" ]]; then
    version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    if [[ "$version" > "$_javaVersion" ]]; then
      printError "❌ Java version is higher than ${_javaVersion}"
    elif [[ "$version" < "$_javaVersion" ]]; then
      printError "❌ Java version is lower than ${_javaVersion}"
    else
      printInfo "✅ Java Version ${version}"
    fi
  fi
}

#   remove arg from path
#   ------------------------------------------------------------
function removeFromPath() {
  export PATH=$(echo $PATH | sed -E -e "s;:$1;;" -e "s;$1:?;;")
}

#   Xcode via @orta
#   --------------------------------------------------------------------
function openx() {
  if test -n "$(find . -maxdepth 1 -name '*.xcworkspace' -print -quit)"; then
    echo "Opening workspace"
    open *.xcworkspace
    return
  else
    if test -n "$(find . -maxdepth 1 -name '*.xcodeproj' -print -quit)"; then
      echo "Opening project"
      open *.xcodeproj
      return
    else
      echo "Nothing found"
    fi
  fi
}

#   Go to the root of the current git project, or just go one folder up
#   --------------------------------------------------------------------
function up() {
  export git_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [ -z $git_dir ]; then
    cd ..
  else
    cd $git_dir
  fi
}

#   mcd:          Makes new Dir and jumps inside
#   --------------------------------------------------------------------
function mcd() {
  mkdir -p "$1" && cd "$1"
}

#   trash:        Moves a file to the MacOS trash
#   --------------------------------------------------------------------
function trash() {
  command mv "$@" ~/.Trash
}

#   ql:           Opens any file in MacOS Quicklook Preview
#   --------------------------------------------------------------------
function ql() {
  qlmanage -p "$*" >&/dev/null
}

#   mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#           displays paginated result with colored search terms and two lines surrounding each hit.
#           Example: mans mplayer codec
#   --------------------------------------------------------------------
function mans() {
  man $1 | grep -iC2 --color=always $2 | less
}

#   showa: to remind yourself of an alias (given some part of it)
#   ------------------------------------------------------------
function showa() {
  /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc
}

#   zipf: To create a ZIP archive of a folder
#   -------------------------------
function zipf() {
  zip -r "$1".zip "$1"
}
