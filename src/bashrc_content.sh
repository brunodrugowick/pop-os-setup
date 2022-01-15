#!/bin/bash

# Adds useful general things to .bashrc.
BASHRC_CONTENT=$(cat <<- 'EOF'

# Re-set PS1 to my liking
function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
if [ "$color_prompt" = yes ]; then
  PS1='\[\033[01;34m\]\w\[\033[00m\] $(parse_git_branch) \n >> '
else
  PS1='\w $(parse_git_branch) \n >> '
fi
unset color_prompt force_color_prompt

# github-compare
function gh-compare () {
  if [ ! -d .git ]; then
    echo "Not a git repository"
    return
  fi;

  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  echo "Current branch is ${CURRENT_BRANCH}"
  MAIN_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
  echo "Main branch is ${MAIN_BRANCH}"

  if [[ "$CURRENT_BRANCH" == "$MAIN_BRANCH" ]]; then
  	echo "Already in ${MAIN_BRANCH}, go to another branch to compare"
	  return
  fi;

  GIT_URL=$(git config --local remote.origin.url | cut -d "@" -f 2 | cut -d "." -f "1-2" | sed "s/:/\//")
  URL="https://${GIT_URL}/compare/${MAIN_BRANCH}...${CURRENT_BRANCH}"
  if [[ "$1" != "" ]]; then
    echo "Opening ${URL}"
    firefox -new-window ${URL}
  else
    echo "URL copied to clipboard"
    echo $URL | xclip -sel clip
  fi;
}
export -f gh-compare

# Uses a temp file to copy from tmux buffer to default buffer
# Thanks to https://github.com/derelbenkoenig/bash-fu/blob/master/bin/tmuxclip
function cliptmux () {
	TEMP_FILE=$(mktemp)
	tmux save-buffer $TEMP_FILE && xclip -sel clip <$TEMP_FILE
}
export -f cliptmux

EOF
)

printf '%s' "$BASHRC_CONTENT" >> "$BASHRC"
