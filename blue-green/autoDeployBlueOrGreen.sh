#!/bin/bash

currentSlot=$(helm get values --all deploy-test | python -c 'import sys,yaml; yml = yaml.safe_load(sys.stdin); print(yml["productionSlot"]);')

if [ $currentSlot == "blue" ]; then
  newSlot=green
elif [ $currentSlot == "green" ]; then
  newSlot=blue
fi

if [ $newSlot == "blue" ]; then
	helm upgrade deploy-test . --set blue.enabled=true --set blue.timestamp="$(date '+%Y-%m-%d %H:%M:%S')" --reuse-values --debug
  kubectl rollout status deployments/bg-deploy-blue
  sleep 2
  helm upgrade deploy-test . --set productionSlot=blue --reuse-values --debug
elif [ $newSlot == "green" ]; then
  helm upgrade deploy-test . --set green.enabled=true --set green.timestamp="$(date '+%Y-%m-%d %H:%M:%S')" --reuse-values --debug
  kubectl rollout status deployments/bg-deploy-green
  sleep 2
  helm upgrade deploy-test . --set productionSlot=green --reuse-values --debug
fi

