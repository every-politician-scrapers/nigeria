#!/bin/bash

cd $(dirname $0)

jq -r '.data[] | @csv' official.json | sed -e 's/  / /g' | qsv rename -n name,state,constituency,party,id | qsv sort -N -s id | ifne tee scraped.csv
wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | ifne tee wikidata.csv
bundle exec ruby diff.rb | qsv sort -s name | tee diff.csv

cd -
