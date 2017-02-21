#!/bin/bash

read -p "what is  your compressed configuration: " pcc
mkdir tmp
[[ -n "$pcc" ]] && tar -xf $pcc -C ./tmp || echo "no configuration"
(cd tmp/$(ls) && mv .* ~)
rm -rf tmp
