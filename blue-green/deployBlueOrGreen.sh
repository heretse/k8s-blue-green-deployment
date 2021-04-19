#!/bin/bash

if [ "$#" -eq  "0" ];
  then
    echo "No arguments supplied"
    exit 1
elif [ "$#" -eq  "1" ];
  then
    newSlot=$1
fi

if [ $newSlot == "blue" ]; then
	helm upgrade deploy-test . --set blue.enabled=true --set blue.timestamp="$(date '+%Y-%m-%d %H:%M:%S')" --reuse-values --debug
elif [ $newSlot == "green" ]; then
  helm upgrade deploy-test . --set green.enabled=true --set green.timestamp="$(date '+%Y-%m-%d %H:%M:%S')" --reuse-values --debug
fi

