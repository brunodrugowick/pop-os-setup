#!/bin/bash

set -ex

if [ -z "$1" ]; then
    echo "Need the title of a Joplin note to get Markdown from."
    exit 1
fi

NOTE_TITLE=$1
FOLDER=$(mktemp -d)
EXTRACTED_MD=$FOLDER/extracted_markdown.md
TYPE="${2:-html}"
OUTPUT=$PWD/slides.$TYPE

sqlite3 ~/.config/joplin-desktop/database.sqlite <<EOF
.headers off
.mode list
.output ${EXTRACTED_MD}
SELECT body from notes where title = '$NOTE_TITLE';
EOF

npx @marp-team/marp-cli $EXTRACTED_MD --${TYPE} -o $OUTPUT

