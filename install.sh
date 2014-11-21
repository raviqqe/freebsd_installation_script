#!/bin/sh

echo "install.sh - initial package installation script"

cat packages.list |
sed 's/#.*//g' |
grep -v '^[[:blank:]]*$' |
while read word1 word2
do
	if [ -z $word2 ]
	then
		echo "installing $word1"
		pkg install -y $word1
	elseif [ $word1 == 'r' ]
	then
		echo "removing $word2"
		pkg remove -y $word2
	fi
done
