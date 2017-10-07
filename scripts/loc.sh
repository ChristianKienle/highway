#!/usr/bin/env bash
cd Sources
locs=$(( find ./ -name '*.swift' -print0 | xargs -0 cat ) | wc -l)
DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo "${DATE}                ${locs}" >> ./../scripts/loc_over_time.text

cat ./../scripts/loc_over_time.text
