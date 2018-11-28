#!/bin/sh

cd src
git checkout 69.0.3497.106_packed > /dev/null 2>&1
if [ $? != 0 ]; then
  echo -e "\e[34m\e[1mpack version not exists\e[0m"
else
  git reset --hard
  rm .gitignore
  find . -type d -name '.git_hidden' -execdir mv .git_hidden .git ';'
  find . -type f -name '.gitignore_hidden' -execdir mv .gitignore_hidden .gitignore ';'
  echo "\e[34m\e[1mtry to git checkout 69.0.3497.106??????????\n\e[0m"
fi
cd ..