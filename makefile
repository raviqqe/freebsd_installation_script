# pkg: install packages listed in packages
# config: install configuration files in files directory to your home
# 
# _gen_config: generate configuration files in files directory

all: pkg config

pkg:
	sh install_pkg.sh

config:
	sh install_conf.sh /home/raviqqe

_gen_conf:
	sh gen_conf.sh

clean:
	rm -f pkg_installed pkg_removed

.PHONY: all clean _gen_config pkg config
