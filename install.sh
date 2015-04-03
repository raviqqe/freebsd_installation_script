#!/bin/sh

error() {
  echo "$*" >&2
}

fail() {
  error "$*"
  exit 1
}

USER=$(stat -f %Su "$1")
GROUP=$(stat -f %Sg "$1")
readonly USER GROUP

echo "install.sh - initial package installation script"

# install pkg command when it's not done yet
if [ -z "$(which pkg)" ]
then
  yes | pkg
fi

# install packages
cat packages.list |
sed 's/#.*//g' |
grep -v '^[[:blank:]]*$' |
while read word1 word2 others
do
  if [ -n "$others" ]
  then
    fail "too many fields in packages.list: $word1 $word2 $others"
  fi

  case $word1 in
  i)
    pkg_installed="$pkg_installed $word1"
    ;;
  r)
    pkg_removed="$pkg_removed $word2"
    ;;
  *)
    fail "invalid letter at the first field: $word1"
  esac
done

pkg install -y $pkg_installed
pkg remove -y $pkg_removed

# copy config files
cd files
mkdir tmp
for file in $(ls)
do
  mv $file tmp/$(echo "$file" | sed 's/DUMMY//g')
done
(
  cd tmp
  install -o "$USER" -g "$GROUP" -m 600 $(ls -A) /home/"$USER"
)
rm -rf tmp
