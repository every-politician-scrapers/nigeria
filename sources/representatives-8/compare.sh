#!/bin/bash

cd $(dirname $0)

# curl https://raw.githubusercontent.com/everypolitician/everypolitician-data/master/data/Nigeria/Representatives/term-8.csv | qsv select wikidata,name,wikidata_group,group,wikidata_area,area,start_date,end_date,gender | qsv rename item,itemLabel,party,partyLabel,area,areaLabel,startDate,endDate,gender > scraped.csv

wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | qsv sort -s itemLabel,startDate > wikidata.csv
bundle exec ruby diff.rb | qsv sort -s itemlabel,startdate | qsv select 1,item,itemlabel,party,gender | tee diff.csv

cd -
