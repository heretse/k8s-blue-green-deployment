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
    helm upgrade deploy-test . --set productionSlot=blue --reuse-values --debug
elif [ $newSlot == "green" ]; then
    helm upgrade deploy-test . --set productionSlot=green --reuse-values --debug
fi