#!/usr/bin/env bash

curl -sS https://ngosang.github.io/trackerslist/trackers_best.txt | sed -E '/^$/d' | paste -d"," -s | sed -E 's/^/bt-tracker=/' >> aria2.conf