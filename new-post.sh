#!/bin/bash

# This script generates a new blog post.
#
# Adapted from: https://github.com/garritfra/garrit.xyz/blob/main/gen-post.sh
#
# Example usage:
# ./new-post.sh My first post

POSITIONAL_ARGS=()
CATEGORY=blog

while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--tech-tips)
      CATEGORY=tech-tips
      shift # past argument
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

DATE=$(date +"%Y-%m-%d")
FULL_DATE=$(date +"%Y-%m-%d %H:%M:%S %z")

TITLE="$@"
FILE_TITLE=$(echo "$TITLE" | tr " " "-" | tr -d "():;?" | tr "[A-Z]" "[a-z]")
FILE_NAME="$DATE-${FILE_TITLE}.md"

FULL_PATH="_posts/$FILE_NAME"

# The first substitution escapes backslashes, the second
# escapes double-quotes. They must be done in this order.
# Credits: https://www.reddit.com/r/linuxquestions/comments/thdjgh/comment/i176z2y
TITLE="${TITLE//\\/\\\\}"
TITLE="${TITLE//\"/\\\"}"

cat > "$COMMON_FRONT_MATTER" <<EOM
date: "${FULL_DATE}"
categories:
  - ${CATEGORY}
tags:
  - note
  - TODO
EOM

if [ $CATEGORY == "tech-tips" ]; then

cat > "$FULL_PATH" <<EOF
---
title: "Tech Tips: ${TITLE}"
excerpt: "TODO"
${COMMON_FRONT_MATTER}
---

{% include tech-tips-head-notice.html %}

# Away We GO!

EOF

else

cat > "$FULL_PATH" <<EOF
---
title: "${TITLE}"
${COMMON_FRONT_MATTER}
---

# Away We GO!

EOF
fi

# TODO until we start this challenge!
# tags: "note, 100DaysToOffload"
