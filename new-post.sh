#!/bin/sh

# This script generates a new blog post.
#
# Adapted from: https://github.com/garritfra/garrit.xyz/blob/main/gen-post.sh
#
# Example usage:
# ./new-post.sh My first post

DATE=$(date +"%Y-%m-%d")
FULL_DATE=$(date +"%Y-%m-%d %H:%M:%S %z")

TITLE="$@"
FILE_TITLE=$(printf "$TITLE" | tr " " "-" | tr "[A-Z]" "[a-z]" | sed s/\?//g)
FILE_NAME="$DATE-$FILE_TITLE.md"

FULL_PATH="_posts/$FILE_NAME"

cat > $FULL_PATH <<EOF
---
title: $TITLE
date: "$FULL_DATE"
categories:
  - blog
tags:
  - note
  - TODO
---

# Away We GO!

EOF

# TODO until we start this challenge!
# tags: "note, 100DaysToOffload"
