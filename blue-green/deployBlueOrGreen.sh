#!/bin/bash

if [ "$#" -eq  "0" ];
  then
    echo "No arguments supplied"
    exit 1
elif [ "$#" -eq  "1" ];
  then
    newSlot=$
    echo "Start to deploy on slot: $newSlot"
elif [ "$#" -eq  "2" ];
  then
    newSlot=$1
    appVersion=$2
    echo "Start to deploy on slot: $newSlot with version: $appVersion"
fi

if [ $newSlot == "blue" ]; then
  kubectl delete deployments/bg-deploy-blue
	helm upgrade deploy-test . --set blue.enabled=true --set blue.timestamp="$(date '+%Y-%m-%d %H:%M:%S')" --set blue.appVersion=$appVersion --reuse-values --debug
elif [ $newSlot == "green" ]; then
  kubectl delete deployments/bg-deploy-green
  helm upgrade deploy-test . --set green.enabled=true --set green.timestamp="$(date '+%Y-%m-%d %H:%M:%S')" --set green.appVersion=$appVersion --reuse-values --debug
fi

