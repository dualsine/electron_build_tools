#!/bin/sh

gclient sync --with_branch_heads -v --gclientfile=.gclient-chromium --no-history --shallow

git clone https://github.com/electron/electron.git --depth=1 src/electron
sed -i "s/checkout_chromium': True/checkout_chromium': False/g" src/electron/DEPS
sed -i "s/'condition': 'checkout_chromium and apply_patches',//g" src/electron/DEPS
sed -i "s/use_jumbo_build = true//g" src/electron/build/args/all.gn

cd src
git checkout e7075c132b1d96ecbf1ca5c89cbeaae46b430fa2
cd ..

gclient sync --with_branch_heads -v --gclientfile=.gclient-electron --with_tags --no-history --shallow
find src/ -type d -name '_gclient_*' -exec rm -r {} \; -prune

cd src
git am < ../blink-patch.patch
cd ..
