#!/bin/sh

cd src
echo -e "\e[34m\e[1mapplying blink patch\n\e[0m"
git am < ../builderos/blink-patch.patch
cd ..
