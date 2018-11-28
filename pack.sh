#!/bin/bash
echo -e "\e[34m\e[1mon start script adding everything what's excluded to new commit:\n\e[0m"
cd src
git checkout 69.0.3497.106_packed > /dev/null 2>&1
if [ $? != 0 ]; then
  git checkout master
  find . -type d -name '.git' -exec sh -c 'x="{}"; mv "$x" "${x}_hidden"' \;  > /dev/null 2>&1
  find . -type f -name '.gitignore' -exec sh -c 'x="{}"; mv "$x" "${x}_hidden"' \;  > /dev/null 2>&1
  echo "**/*.gz\n**/*.bz2\n**/*.zip\nout/\n" > .gitignore
  mv .git_hidden .git
  echo -e "\e[34m\e[1madding all files to git repository... (it take a while)\n\e[0m"
  git add . > /dev/null 2>&1
  echo -e "\e[34m\e[1mcreating big commit...\n\e[0m"
  git commit -m 'packed' > /dev/null 2>&1
  echo -e "\e[34m\e[1madding tag and removing all files...\n\e[0m"
  git tag 69.0.3497.106_packed > /dev/null 2>&1
  rm -rf * > /dev/null 2>&1
  git checkout master > /dev/null 2>&1
  echo -e "\e[34m\e[1mmaking checkout and hiding files again - for smaller repo size...\n\e[0m"
  git reset --hard > /dev/null 2>&1
  rm -rf * > /dev/null 2>&1
  git checkout master > /dev/null 2>&1
else
  echo -e "\e[34m\e[1mpacked version exists! - preparing to hide...\n\e[0m"
  #rm -rf * > /dev/null 2>&1
fi
echo -e "\e[34m\e[1mnow you can compress entire directory - 'lrztar -z src'\n\e[0m"
cd ..
