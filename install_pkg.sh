#!/bin/sh

error() {
  echo "$*" >&2
}

fail() {
  error "$*"
  exit 1
}

echo "install_pkg.sh - initial package installation script"

# install pkg command when it's not done yet
if [ -z "$(which pkg)" ]
then
  yes | pkg
fi

# install packages
cat packages.list |
sed 's/#.*//g' |
grep -v '^[[:blank:]]*$' | (
  while read word1 word2 others
  do
    if [ -n "$others" ]
    then
      fail "too many fields in packages.list: $word1 $word2 $others"
    fi
  
    case $word1 in
    i)
      pkg_installed="$pkg_installed $word2"
      ;;
    r)
      pkg_removed="$pkg_removed $word2"
      ;;
    *)
      fail "invalid letter at the first field: $word1"
    esac
  done
  echo $pkg_installed > pkg_installed
  echo $pkg_removed > pkg_removed
)

test -s pkg_installed && pkg install -y $(cat pkg_installed)
test -s pkg_removed && pkg delete -y $(cat pkg_removed)

test -f pkg_installed && rm pkg_installed
test -f pkg_removed && rm pkg_removed
