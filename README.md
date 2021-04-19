# Blue-Green Deployment using Helm Charts on Kubernetes

## Installation
### Prerequisites

* Install Helm3
```
$ curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
$ chmod 700 get_helm.sh
$ ./get_helm.sh
```

* Install Istio
```
$ wget https://github.com/istio/istio/releases/download/1.9.3/istio-1.9.3-osx.tar.gz
$ tar zxvf istio-1.9.3-osx.tar.gz
$ cd istio-1.9.3
$ helm install istio-base manifests/charts/base -n istio-system
$ helm install istiod manifests/charts/istio-control/istio-discovery -n istio-system
$ helm install istio-ingress manifests/charts/gateways/istio-ingress -n istio-system
```
* Create namespace - blue-green and add label for Istio auto injection
```
$ kubectl create namespace my-app
$ kubectl label namespace my-app istio.io/rev=1-9-3
$ kubectl config set-context --current --namespace my-app
```
### Running for blue-green deployment

* Change directory to blue-green helm chart
```
$ cd blue-green
```

* Blue deployment with Helm install and specific traffic to blue
```
$ helm install deploy-test . --namespace=my-app --set blue.enabled=true --set blue.timestamp="$(date '+%Y-%m-%d %H:%M:%S')" --set productionSlot=blue --debug
``` 

* Green deployment with Helm upgrade
```
$ ./deployBlueOrGreen.sh green
```

* Checkout rolling update status is ready
```
$ kubectl rollout status deployments/deploy-test-blue-green-green -n my-app
deployment "deploy-test-my-app-green" successfully rolled out
```

* Move traffic to green
```
$ ./moveTraffic.sh green
```

* Repeat the steps for blue deployment again
```
$ ./deployBlueOrGreen.sh blue
$ kubectl rollout status deployments/deploy-test-blue-green-blue -n my-app
$ ./moveTraffic.sh blue
```