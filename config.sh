#!/bin/bash
swap_space=1      # 1=install, 0=do not install

nginx=1           # 1=install, 0=do not install

php=1             # 1=install, 0=do not install
php_version=8.3   # version (e.g., 8.3)

composer=1        # 1=install, 0=do not install

node_and_npm=1    # 1=install, 0=do not install

redis=1           # 1=install, 0=do not install

sqlite=1          # 1=install, 0=do not install

# note that only one of the following can be installed
mysql=1           # 1=install, 0=do not install
mariadb=0         # 1=install, 0=do not install
db_root_password=secret # db root password

certbot=1         # 1=install, 0=do not install

apache=0          # 1=install, 0=do not install

memcache=0        # 1=install, 0=do not install

beanstalk=0       # 1=install, 0=do not install

mailhog=0         # 1=install, 0=do not install

ngrok=0           # 1=install, 0=do not install

postfix=0         # 1=install, 0=do not install



