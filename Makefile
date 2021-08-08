do-k8s:
	doctl kubernetes cluster create k8s `
	--region=nyc1 `
	--node-pool "name=k8s-pool;size=s-1vcpu-2gb-amd;count=2"

deploy-apps
	kubectl apply -f apps/hello-kubernetes-first.yaml
	kubectl apply -f apps/hello-kubernetes-second.yaml

install-ingress:
	# Downlaoad yaml file
	wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.48.1/deploy/static/provider/do/deploy.yaml
	ren deploy.yaml do-nginx-ingress-controller.yaml
	# Change externalTrafficPolicy so that LoadBalancer will work as excected
	(Get-Content -path .\do-nginx-ingress-controller.yaml -Raw) -replace 'externalTrafficPolicy: Local','externalTrafficPolicy: Cluster' | Set-Content -Path .\ingress-controller.yaml
	# Search for controller-service.yaml and add the follwoing line to annotations 
		service.beta.kubernetes.io/do-loadbalancer-name: 'main-lb'
		service.beta.kubernetes.io/do-loadbalancer-hostname: personal-private-network.com
	kubectl apply -f do-nginx-ingress-controller.yaml
    watch kubectl get services ingress-nginx-controller -n ingress-nginx -o jsonpath="{.status.loadBalancer.ingress[0].ip}"
install-helm:
	#helm version 3 doesn't require server configration
	#kubectl create serviceaccount tiller --namespace kube-system
	#kubectl create -f tiller.yaml
	#helm init --service-account tiller --upgrade
	helm repo add jetstack https://charts.jetstack.io
	
deploy:
	kubectl apply -R -f applications/

install-cert-manager:
	kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.6/deploy/manifests/00-crds.yaml
	kubectl label namespace kube-system certmanager.k8s.io/disable-validation="true"
	helm install cert-manager --namespace kube-system jetstack/cert-manager

install-cert-manager-issuers:
	kubectl apply -f cert-manager/staging.yaml
	kubectl apply -f cert-manager/production.yaml