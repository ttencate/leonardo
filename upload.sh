#!/bin/bash

cd "$(dirname "$0")"

haxelib run lime build html5 && \
  cp -R ./gif ./export/html5/bin/ && \
  rsync -rpltv --delete ./export/html5/bin/ frozenfractal.com:/var/www/leonardo.frozenfractal.com/
