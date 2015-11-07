#!/bin/sh

date_pattern=`date "+%Y-%m-%d"`-

read -r -p "Project name > "
title=${REPLY}
clean_title=`echo $title | tr "[:upper:]" "[:lower:]"]` #Lower Case
clean_title=`echo $clean_title | iconv -f utf-8 -t ascii//translit` #Remove accents
clean_title=`echo $clean_title | tr -dc "[a-z ]"` #Keep spaces and letters
clean_title=`echo $clean_title | tr " " "-"` #Replace spaces by dashes

filename=$date_pattern$clean_title.md

read -r -p "Image > "
image=${REPLY}

read -r -p "Link > "
link=${REPLY}

read -r -p "Description > "
description=${REPLY}

cat > "projects/"$filename <<EOF
---
title: $title
link: $link
image: $image
description: $description
---

EOF

$EDITOR "projects/"$filename
