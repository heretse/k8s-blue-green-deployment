#!/bin/bash

currentSlot=$((helm get values --all deploy-test) || echo 'productionSlot: green') | python -c 'import sys,yaml; yml = yaml.safe_load(sys.stdin); print(yml["productionSlot"]);')

if [ $currentSlot == "blue" ]; then
  newSlot=green
elif [ $currentSlot == "green" ]; then
  newSlot=blue
fi

newAppVersion=$(helm get values --all deploy-test | sed -e "s/^$newSlot:/current:/" | python -c 'import sys,yaml; yml = yaml.safe_load(sys.stdin); print(yml["current"]["appVersion"]);')
if [ "$#" -eq  "1" ];
  then
    newAppVersion=$1
fi
echo "Start to deploy on slot: $newSlot with version: $newAppVersion"

if [ $newSlot == "blue" ]; then
  kubectl delete deployments/bg-deploy-blue
  helm upgrade deploy-test . --set blue.enabled=true --set blue.timestamp="$(date '+%Y-%m-%d %H:%M:%S')" --set blue.appVersion=$newAppVersion --reuse-values --debug
  kubectl rollout status deployments/bg-deploy-blue
  sleep 2
  helm upgrade deploy-test . --set productionSlot=blue --reuse-values --debug
elif [ $newSlot == "green" ]; then
  kubectl delete deployments/bg-deploy-green
  helm upgrade deploy-test . --set green.enabled=true --set green.timestamp="$(date '+%Y-%m-%d %H:%M:%S')" --set green.appVersion=$newAppVersion --reuse-values --debug
  kubectl rollout status deployments/bg-deploy-green
  sleep 2
  helm upgrade deploy-test . --set productionSlot=green --reuse-values --debug
fi

