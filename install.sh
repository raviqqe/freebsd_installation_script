#!/bin/sh

USER=raviqqe
GROUP=$USER
readonly USER GROUP

echo "install.sh - initial package installation script"

# install pkg command when it's not done yet
yes | pkg

# install packages
cat packages.list |
sed 's/#.*//g' |
grep -v '^[[:blank:]]*$' |
while read word1 word2 others
do
  if [ -n "$others" ]
  then
    echo extra fields detected >&2
    exit 1
  fi

  case $word1 in
  i)
		echo installing $word2
		pkg install -y $word2
    ;;
  r)
		echo removing $word2
		pkg remove -y $word2
    ;;
  *)
    echo invalid letter at the first field >&2
    exit 1
  esac
done

# copy config files
install -o "$USER" -g "$GROUP" -m 600 files/.* /home/$USER
