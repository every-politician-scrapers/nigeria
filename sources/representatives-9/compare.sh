#!/bin/bash

cd $(dirname $0)

bundle exec ruby scraper.rb $(jq -r .source meta.json) | ifne tee scraped.csv
wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | qsv sort -s itemLabel,startDate | ifne tee wikidata.csv
bundle exec ruby diff.rb | qsv sort -s itemlabel,startdate | tee diff.csv

cd -
