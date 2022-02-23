#!/bin/bash

# Install Composer
sudo curl -sS https://getcomposer.org/installer | sudo php
sudo mv composer.phar /usr/local/bin/composer


# Install Global Packages
sudo su $username <<'EOF'
/usr/local/bin/composer global require "laravel/envoy=^2.0"
/usr/local/bin/composer global require "laravel/installer=^4.0.2"
/usr/local/bin/composer global require "laravel/spark-installer=dev-master"
/usr/local/bin/composer global require "slince/composer-registry-manager=^2.0"
/usr/local/bin/composer global require tightenco/takeout
EOF

# Add Composer Global Bin To Path
#sudo printf "\nPATH=\"$(sudo su - $username -c 'composer config -g home 2>/dev/null')/vendor/bin:\$PATH\"\n" | sudo tee -a /home/$username/.profile