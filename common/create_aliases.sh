#!/bin/bash

if [ ! -f ~/.bash_aliases ]; then
    touch ~/.bash_aliases
fi

declare -a aliases=(
"alias create_app='/usr/local/bin/devops/deploy/create_app.sh'"
"alias delete_app='/usr/local/bin/devops/deploy/delete_app.sh'"
                )

for alias_str in "${aliases[@]}"
do
   echo "$alias_str"
   if grep -q "$alias_str" ~/.bash_aliases; then
    echo "Alias Already Exists: $alias_str"
  else
    echo "$alias_str" >> ~/.bash_aliases
    source ~/.bashrc
    echo "Alias Created: $alias_str"
  fi
done
