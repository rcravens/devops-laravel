#!/bin/bash

if [ ! -f ~/.bash_aliases ]; then
    touch ~/.bash_aliases
fi

declare -a aliases=(
"alias create_app='/usr/local/bin/devops/deploy/create_app.sh'"
"alias create_app='/usr/local/bin/devops/deploy/create_app.sh'"
                )

for i in "${aliases[@]}"
do
   echo "$i"
   # or do whatever with individual element of the array
done

exit

alias_str="alias create_app='/usr/local/bin/devops/deploy/create_app.sh'"
if grep -q "$alias_str" ~/.bash_aliases; then
  echo "Alias Already Exists: /home/$username/.bash_aliases"
else
  echo "$alias_str" >> ~/.bash_aliases
  source ~/.bashrc
  echo "Alias Created: /home/$username/.bash_aliases"
fi
