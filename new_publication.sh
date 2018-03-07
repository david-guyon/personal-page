#!/bin/sh

date_pattern=`date "+%Y-%m-%d"`-

read -r -p "Publication name > "
title=${REPLY}
clean_title=`echo $title | tr "[:upper:]" "[:lower:]"]` #Lower Case
clean_title=`echo $clean_title | iconv -f utf-8 -t ascii//translit` #Remove accents
clean_title=`echo $clean_title | tr -dc "[a-z ]"` #Keep spaces and letters
clean_title=`echo $clean_title | tr " " "-"` #Replace spaces by dashes

filename=$date_pattern$clean_title.md

read -r -p "Authors > "
authors=${REPLY}

read -r -p "Abstract > "
abstract=${REPLY}

read -r -p "Link > "
link=${REPLY}

read -r -p "Description > "
description=${REPLY}

read -r -p "Conference > "
conference=${REPLY}

read -r -p "Conference link > "
conference_link=${REPLY}

read -r -p "Paper type > "
paper_type=${REPLY}

cat > "publications/"$filename <<EOF
---
title: $title
authors: $authors
abstract: $abstract
link: $link
description: $description
conference: $conference
conf-link: $conference_link
paper-type: $paper_type
---

EOF

$EDITOR "publications/"$filename
