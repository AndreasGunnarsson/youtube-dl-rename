#!/bin/bash

if (( $# > 0 )); then
  echo "Genre: $1"
else
  echo "Error. No genre specified."
  exit 1
fi

array=( * )

echo -e "\nRenaming files.."
tagArray=()
for file in "${array[@]}"; do
  if [[ -f $file ]]; then
    echo "  Original filename: $file"
    rename=$file
    if [[ $file == *#NA#* ]]; then
      rename=${rename/"}}"}
      rename=${rename#*\{\{*}
      mv "$file" "$rename"
      tagArray+=("$rename")
      echo "    Renamed: $rename"
    elif [[ $file == *{{* && *}}* ]]; then
      rename=${rename/\{\{*\}\}/""}
      mv "$file" "$rename"
      tagArray+=("$rename")
      echo "    Renamed: $rename"
    else
      echo "    No rename performed."
    fi
  fi
done

echo -e "\nDone renaming files. Adding id3tags.."
for file2 in "${tagArray[@]}"; do
  echo "  Filename: $file2"
  artist=$file2
  artist=${artist%*_-_*}
  artist=${artist//_/" "}
  echo "    Artist: $artist"
  title=$file2
  title=${title#*_-_*}
  title=${title%_[*}
  title=${title//_/" "}
  echo "    Title: $title"

  kid3-cli -c "set artist ${artist@Q}" -c "set title ${title@Q}" -c "set genre ${1@Q}" $file2
done

echo -e "\nCompleted."
