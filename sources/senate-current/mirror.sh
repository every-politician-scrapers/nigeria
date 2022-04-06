#!/bin/bash

cd $(dirname $0)

if [[ $(jq -r .source meta.json) == http* ]]
then
  CURLOPTS='-L -c /tmp/cookies -A eps/1.2'
  curl $CURLOPTS -o official.json $(jq -r .source meta.json)
fi

cd ~-
