#!/bin/bash

rm -rf _gclient*

mkdir -p src
cd src
if [ -d .git ]; then
  echo "chromium src exists\n";
else
  git init
  git remote add origin https://github.com/chromium/chromium.git
  git fetch --depth=1 origin 69.0.3497.106
  git checkout FETCH_HEAD
fi;
cd ..

builderos/chrome_deps_helper.rb

gclient_path="$(ls $(which gclient))"
echo "replacing $gclient_path.py"
sed -i "s/self.error('--gclientfile target must be a filename, not a path')/print('opening gclient file')/g" "$gclient_path.py"
gclient sync --with_branch_heads --gclientfile=builderos/.gclient-chromium --no-history --shallow

cd src
git clone --branch v4.0.0-nightly.20181010 https://github.com/electron/electron.git --depth=1
cd ..
sed -i "s/checkout_chromium': True/checkout_chromium': False/g" src/electron/DEPS
sed -i "s/'condition': 'checkout_chromium and apply_patches',//g" src/electron/DEPS
sed -i "s/use_jumbo_build = true//g" src/electron/build/args/all.gn

cd src
git checkout 69.0.3497.106
cd ..

gclient sync --with_branch_heads -v --gclientfile=builderos/.gclient-electron --with_tags --no-history --shallow
find src/ -type d -name '_gclient_*' -exec rm -r {} \; -prune

cd src
git am < ../builderos/blink-patch.patch
cd ..

cp builderos/gn_electron_release.sh src/.
cp builderos/gn_electron_debug.sh src/.
