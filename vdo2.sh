#!/bin/sh
#it takes path to directory and output file name as argument
path="$1"
op="$2"
#for creating the file having video names
echo "folder name: $path"
echo "output file : $op"
#making a new intermediate directory for storing intermediate videos
mkdir "$path/test_dir"
name="vdomerger"
if [ -e $name.txt ] ; then
    i=0
    while [ -e $name-$i.txt ];  do
        i=$((i+1))
    done
    name=$name-$i
fi
touch "$name".txt


j=0
for entry in "$path"/*;
do
  if [ -f "$entry" ];
  then
  echo "$entry"
  ffmpeg -i $entry -qscale:v 1 "$path/test_dir/mediate-$j".mpg
  echo "file '$path/test_dir/mediate-$j'.mpg" >> "$name".txt
  j=$((j+1))
  fi
done
sort "$name".txt -o "$name".txt
#for merging the videos 
ffmpeg -f concat -safe 0 -i "$name".txt  -c copy -flags +global_header "$path/test_dir/medout".mpg
#for converting the type as output format
ffmpeg -i "$path/test_dir/medout".mpg -qscale:v 2 -strict experimental "$path/$op"
#for deleting intermediate files and directories
rm -f "$name".txt
rm -rf "$path/test_dir"

