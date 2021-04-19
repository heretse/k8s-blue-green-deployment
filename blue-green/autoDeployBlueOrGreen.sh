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
  kubectl rollout status deployments/deploy-test-blue-green-blue
  kubectl get virtualservice deploy-test-blue-green-vs -o yaml | python -c 'import sys,yaml; yml = yaml.safe_load(sys.stdin); yml["spec"]["http"][0]["route"][0]["weight"]=100; yml["spec"]["http"][0]["route"][1]["weight"]=0; print(yaml.dump(yml));' | kubectl apply -f -
elif [ $newSlot == "green" ]; then
  helm upgrade deploy-test . --set green.enabled=true --set green.timestamp="$(date '+%Y-%m-%d %H:%M:%S')" --reuse-values --debug
  kubectl rollout status deployments/deploy-test-blue-green-green
  kubectl get virtualservice deploy-test-blue-green-vs -o yaml | python -c 'import sys,yaml; yml = yaml.safe_load(sys.stdin); yml["spec"]["http"][0]["route"][0]["weight"]=0; yml["spec"]["http"][0]["route"][1]["weight"]=100; print(yaml.dump(yml));' | kubectl apply -f -
fi

