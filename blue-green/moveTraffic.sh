#!/bin/bash

if [ "$#" -eq  "0" ];
  then
    echo "No arguments supplied"
    exit 1
elif [ "$#" -eq  "1" ];
  then
    currentSlot=$1
fi

if [ $currentSlot == "blue" ]; then
    kubectl get virtualservice deploy-test-blue-green-vs -n blue-green -o yaml | python -c 'import sys,yaml; yml = yaml.safe_load(sys.stdin); yml["spec"]["http"][0]["route"][0]["weight"]=100; yml["spec"]["http"][0]["route"][1]["weight"]=0; print(yaml.dump(yml));' | kubectl apply -f -
elif [ $currentSlot == "green" ]; then
    kubectl get virtualservice deploy-test-blue-green-vs -n blue-green -o yaml | python -c 'import sys,yaml; yml = yaml.safe_load(sys.stdin); yml["spec"]["http"][0]["route"][0]["weight"]=0; yml["spec"]["http"][0]["route"][1]["weight"]=100; print(yaml.dump(yml));' | kubectl apply -f -
fi

# kubectl get virtualservice deploy-test-blue-green-vs -n blue-green -o yaml | python -c 'import sys,yaml; yml = yaml.safe_load(sys.stdin); print(yaml.dump(yml["spec"]["http"][0]["route"]));'