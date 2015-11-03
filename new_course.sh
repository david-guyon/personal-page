#!/bin/sh

date_pattern=`date "+%Y-%m-%d"`-

read -r -p "Course name > "
title=${REPLY}
clean_title=`echo $title | tr "[:upper:]" "[:lower:]"]` #Lower Case
clean_title=`echo $clean_title | iconv -f utf-8 -t ascii//translit` #Remove accents
clean_title=`echo $clean_title | tr -dc "[a-z ]"` #Keep spaces and letters
clean_title=`echo $clean_title | tr " " "-"` #Replace spaces by dashes

filename=$date_pattern$clean_title.md

read -r -p "Long name > "
long_title=${REPLY}

cat > "courses/"$filename <<EOF
---
title: $title
long-title: $long_title
---

EOF

$EDITOR "courses/"$filename
