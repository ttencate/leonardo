#!/bin/bash

haxelib run lime build html5 && \
  rsync -rpltv --delete ./export/html5/bin/ frozenfractal.com:/var/www/leonardo.frozenfractal.com/
