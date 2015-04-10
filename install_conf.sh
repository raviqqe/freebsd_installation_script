#!/bin/sh

error() {
  echo "$*" >&2
}

fail() {
  error "$*"
  exit 1
}

echo "install_conf.sh - initial package installation script"

if [ $# -ne 1 ]
then
  fail "usage: $0 <home_directory>"
fi

USER=$(stat -f %Su "$1")
GROUP=$(stat -f %Sg "$1")
readonly USER GROUP

# copy config files
cd files
mkdir tmp
for file in $(ls | sed 's/tmp//g')
do
  cp -R $file tmp/$(echo "$file" | sed 's/DUMMY//g')
done
(
  cd tmp
  for file in $(ls -A)
  do
    cp -R $file /home/"$USER"
    chown -R "$USER":"$GROUP" /home/"$USER"/$file
    chmod -R 600 /home/"$USER"/$file
  done
)
rm -rf tmp
