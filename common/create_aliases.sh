#!/bin/bash

if [ ! -f ~/.bash_aliases ]; then
    touch ~/.bash_aliases
fi

declare -a aliases=(
"alias appList='/usr/local/bin/devops/deploy/list_apps.sh'"
"alias appNew='/usr/local/bin/devops/deploy/new_app_form.sh'"
"alias appCreate='/usr/local/bin/devops/deploy/create_app.sh'"
"alias appDelete='/usr/local/bin/devops/deploy/delete_app.sh'"
                )
need_to_resource=0
for alias_str in "${aliases[@]}"
do
   if grep -q "$alias_str" ~/.bash_aliases; then
    echo "Alias Already Exists: $alias_str"
  else
    echo "$alias_str" >> ~/.bash_aliases
    echo "Alias Created: $alias_str"
    need_to_resource=1
  fi
done

if [ $need_to_resource -eq 1 ]; then
  source ~/.bashrc
  echo "To use the new aliases, you may need to run: source ~/.bashrc"
fi
