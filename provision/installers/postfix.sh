#!/bin/bash

# Install & Configure Postfix
sudo echo "postfix postfix/mailname string homestead.test" | sudo debconf-set-selections
sudo echo "postfix postfix/main_mailer_type string 'Internet Site'" | sudo debconf-set-selections
sudo apt-get install -y postfix
sudo sed -i "s/relayhost =/relayhost = [localhost]:1025/g" /etc/postfix/main.cf
sudo /etc/init.d/postfix reload