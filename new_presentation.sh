#!/bin/sh

date_pattern=`date "+%Y-%m-%d"`-

read -r -p "Presentation name > "
title=${REPLY}
clean_title=`echo $title | tr "[:upper:]" "[:lower:]"]` #Lower Case
clean_title=`echo $clean_title | iconv -f utf-8 -t ascii//translit` #Remove accents
clean_title=`echo $clean_title | tr -dc "[a-z ]"` #Keep spaces and letters
clean_title=`echo $clean_title | tr " " "-"` #Replace spaces by dashes

filename=$date_pattern$clean_title.md

read -r -p "Authors > "
authors=${REPLY}

read -r -p "File location > "
link=${REPLY}

read -r -p "Description > "
description=${REPLY}

read -r -p "Conference > "
conference=${REPLY}

read -r -p "Conference link > "
conference_link=${REPLY}

read -r -p "Conference location > "
location=${REPLY}

cat > "presentations/"$filename <<EOF
---
title: $title
authors: $authors
link: $link
description: $description
conference: $conference
conf-link: $conference_link
location: $location
---

EOF

$EDITOR "presentations/"$filename
