#!/bin/bash
echo -e "\e[34m\e[1minstalling system updates\n";
sudo apt update
sudo apt install python-pip
sudo apt install python3-pip
pip install gitpython
pip3 install gitpython

sudo apt-get install build-essential clang libdbus-1-dev libgtk-3-dev \
                       libnotify-dev libgnome-keyring-dev libgconf2-dev \
                       libasound2-dev libcap-dev libcups2-dev libxtst-dev \
                       libxss1 libnss3-dev gcc-multilib g++-multilib curl \
                       gperf bison python-dbusmock

echo -e "\e[34m\e[1mpreparing depot_tools\n";
rm -rf builderos/depot_tools
git submodule update --init

cd builderos/depot_tools
git checkout 44d4b29082f0d8bacacd623f91c4d29637b4b901
git am --signoff < ../depot.patch
cd ../..

rm -rf _gclient*

mkdir -p src
cd src
if [ -d .git ] && [ -d third_party ]; then
  echo -e "\e[34m\e[1mchromium src exists\n\e[0m";
else
  echo -e "\e[34m\e[1mdownloading chromium 69.0.3497.106\n\e[0m"
  git init
  git remote add origin https://github.com/chromium/chromium.git
  git fetch --depth=1 origin 69.0.3497.106
  git checkout FETCH_HEAD
  git checkout -b master
  git tag 69.0.3497.106
  sed -i "s/checkout_libaom': False/checkout_libaom': True/g" DEPS
  git add DEPS
  echo -e "\e[34m\e[1mupdating chromium DEPS file for electron builder tools...\e[0m"
  git commit --amend --no-edit > /dev/null 2>&1
fi;
cd ..

builderos/chrome_deps_helper.rb
echo -e "\e[34m\e[1mLaunching gclient sync for chrome\e[0m"
builderos/depot_tools/gclient sync --with_branch_heads --gclientfile=builderos/.gclient-chromium --no-history --shallow

cd src
mkdir -p electron
cd electron
if [ -d .git ] && [ -f DEPS ]; then
  echo -e "\e[34m\e[1melectron src exists\n\e[0m";
else
  echo -e "\e[34m\e[1mdownloading electron v4.0.0-nightly.20181010\n\e[0m";
  git init
  git remote add origin https://github.com/electron/electron.git > /dev/null 2>&1
  git fetch origin master
  git reset --hard ae266e2e0377c4b2ef8051c1e5562a1ec169005a
  git tag 4.0.0-nightly.20181010_ae266e2
fi;
cd ../..
sed -i "s/checkout_chromium': True/checkout_chromium': False/g" src/electron/DEPS
sed -i "s/'condition': 'checkout_chromium and apply_patches',//g" src/electron/DEPS
sed -i "s/use_jumbo_build = true//g" src/electron/build/args/all.gn

cd src
git am --abort > /dev/null 2>&1
git checkout master
git reset --hard e7075c132b1d96ecbf1ca5c89cbeaae46b430fa2
cd ..

echo -e "\e[34m\e[1mLaunching gclient sync for electron\e[0m"
builderos/depot_tools/gclient sync --with_branch_heads --gclientfile=builderos/.gclient-electron --with_tags --no-history --shallow
find src/ -type d -name '_gclient_*' -exec rm -r {} \; -prune

cd src
echo -e "\e[34m\e[1mapplying blink patch\n\e[0m"
git am < ../builderos/blink-patch.patch
cd ..

echo -e "\e[34m\e[1mcopying gn_electron_release.sh & gn_electron_debug.sh to src/\n\e[0m"
cp builderos/gn_electron_release.sh src/.
cp builderos/gn_electron_debug.sh src/.
