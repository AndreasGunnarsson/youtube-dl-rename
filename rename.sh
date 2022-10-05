#!/bin/bash

while [ ! -z "$1" ]; do
  if [[ "$1" == "-g" ]]; then
    genre=$2
    echo "Genre: $genre"
    shift 1
  elif [[ "$1" == "-a" ]]; then
    album="$2"
    echo "Album: $album"
    shift 1
  elif [[ $1 == "-y" ]]; then
    year="$2"
    echo "Year: $year"
    shift 1
  elif [[ $1 == "-i" ]]; then
    input="$2"
    echo "Input dir: $input"
    shift 1
  elif [[ $1 == "-o" ]]; then
    output="$2"
    echo "Output dir: $output"
    shift 1
  else
    echo "Unknown argument: $1"
  fi
  shift 1
done

if [[ ! -d $input ]]; then
  echo "Not a valid input directory. Exiting."
  exit 1
elif [[ ! -d $output ]]; then
  echo "Not a valid output directory. Exiting."
  exit 1
fi

array=( $input* )

echo -e "\nRenaming files.."
tagArray=()
for file in "${array[@]}"; do
  if [[ -f $file ]]; then
    echo "  Original filename: ${file#$input}"
    rename=${file#$input}
    if [[ $rename == *#NA#* ]]; then
      rename=${rename/"}}"}
      rename=${rename#*\{\{*}
      cp "$file" "$output$rename"
      tagArray+=("$rename")
      echo "    Renamed: $rename"
    elif [[ $rename == *{{* && *}}* ]]; then
      rename=${rename/\{\{*\}\}/""}
      cp "$file" "$output$rename"
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

  kid3-cli -c "set TPE1 ${artist@Q}" -c "set TIT2 ${title@Q}" $output$file2
  if [ ! -z "$genre" ]; then
    kid3-cli -c "set TCON ${genre@Q}" $output$file2
  fi
  if [ ! -z "$album" ]; then
    kid3-cli -c "set TALB ${album@Q}" $output$file2
  fi
  if [ ! -z "$year" ]; then
    kid3-cli -c "set TDRC ${year@Q}" $output$file2
  fi
done

echo -e "\nCompleted."
