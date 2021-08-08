# my-do-cloud
my first tutorial for setting up a k8s cluster on digitlocean

I will follow the comunity tutorial at https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-on-digitalocean-kubernetes-using-helm
to setup :
1. k8s cluster 
1. nginx ingress controller
    I follow the follwoing custome steps 
    1. download the yaml file for digitalocean from the link https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.48.1/deploy/static/provider/do/deploy.yaml
    1. edit the file 
        1. add annotation to the load balancer service to set a loadbalancer friendly name.
        1. change externalTrafficPolicy to Clsuter to make the Loadbalancer work as aexcpected.
        1. Add service.beta.kubernetes.io/do-loadbalancer-hostname annotation to the loadbalncer pointing the domain name, this is required for certmanger to work propertly.
1. cert manager with lets encrypt issuer
1. update my domain records
1. deploy two sample applications
