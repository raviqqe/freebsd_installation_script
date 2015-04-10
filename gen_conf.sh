#!/bin/sh

HOME=/home/raviqqe

cat config_files.list |
while read file
do
  cp -R "${HOME}/${file}" files/DUMMY${file}
done
