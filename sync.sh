#!/bin/sh

git clone -o 69.0.3497.106 https://github.com/chromium/chromium.git --depth=1 src
ruby builderos/chrome_deps_helper.rb

gclient_path="$(ls $(which gclient))"
echo "replacing $gclient_path.py"
sed -i "s/self.error\('--gclientfile target must be a filename, not a path'\)/print('openning gclient from path')/g" "$gclient_path.py"

gclient sync --with_branch_heads -v --gclientfile=builderos/.gclient-chromium --no-history --shallow

git clone -o d7d4b8638d2d9f065ac78895da49a83ddc21a7c8 https://github.com/electron/electron.git --depth=1 src/electron
sed -i "s/checkout_chromium': True/checkout_chromium': False/g" src/electron/DEPS
sed -i "s/'condition': 'checkout_chromium and apply_patches',//g" src/electron/DEPS
sed -i "s/use_jumbo_build = true//g" src/electron/build/args/all.gn

cd src
git checkout e7075c132b1d96ecbf1ca5c89cbeaae46b430fa2
cd ..

gclient sync --with_branch_heads -v --gclientfile=builderos/.gclient-electron --with_tags --no-history --shallow
find src/ -type d -name '_gclient_*' -exec rm -r {} \; -prune

cd src
git am < ../builderos/blink-patch.patch
cd ..

cp builderos/gn_electron_release.sh src/.
cp builderos/gn_electron_debug.sh src/.
