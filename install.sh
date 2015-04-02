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
while read word1 word2
do
  case word1 in
  i)
		echo installing $word2
		pkg install -y $word2
    ;;
  r)
		echo removing $word2
		pkg remove -y $word2
    ;;
  *)
    echo invalid letter at the first field
    exit 1
  esac
done

# copy config files
install -o "$USER" -g "$GROUP" -m 600 files/.* /home/$USER
