#!/bin/bash

if [ -z "$GO_VERSION" ]; then
  echo "Standalone run. Setting up vars"
  # Make sure to update config.properties if you change this section of the script

  BASHRC=$HOME/.bashrc
  GO_VERSION=1.16.5
fi

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

# Allow me to name Gnome workspaces
function workspace-names () {
FILE=~/.workspace-names
touch $FILE

WORKSPACE=$1
shift
NEW_NAME="$@"
NUM_WORKSPACES=$(wc -l < $FILE)

if [[ $WORKSPACE -gt 0 && $NUM_WORKSPACES -ge $WORKSPACE ]];
then
	# Replacing existing workspace name
	sed -i ''"$WORKSPACE"'s/.*/'"$NEW_NAME"'/' $FILE
elif [[ $WORKSPACE -gt $NUM_WORKSPACES  ]]; 
then
	# 'New' workspace name
	# Get to that point
	START_POINT=$(($NUM_WORKSPACES + 1))
	for i in $(seq $START_POINT $WORKSPACE); do
		echo "$i" >> $FILE
	done
	# Write new name (actually replacing the line number just added)
	sed -i ''"$WORKSPACE"'s/.*/'"$NEW_NAME"'/' $FILE
else
	echo "Give me a workspace number and its name"
	exit 1
fi

WORKSPACES=$(cat $FILE)
N=""
for line in $WORKSPACES
do
	N=$N\'$line\'\,
done
# Remove last comma
GNOME_COMMAND_NAMES=${N%,*}

# Set workspaces names
gsettings set org.gnome.desktop.wm.preferences workspace-names "[$GNOME_COMMAND_NAMES]"

}

export -f workspace-names

EOF
)

printf '%s' "$BASHRC_CONTENT" >> "$BASHRC"
