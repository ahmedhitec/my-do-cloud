# my-do-cloud
my first tutorial for setting up a k8s cluster on digitlocean

I will follow the comunity tutorial at https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-on-digitalocean-kubernetes-using-helm
to setup :
1. # k8s cluster 
1. # nginx ingress controller
    I follow the follwoing custome steps 
    1. download the yaml file for digitalocean from the link https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.48.1/deploy/static/provider/do/deploy.yaml
    1. edit the file 
        1. add annotation to the load balancer service to set a loadbalancer friendly name.
        1. change externalTrafficPolicy to Clsuter to make the Loadbalancer work as aexcpected.
        1. Add service.beta.kubernetes.io/do-loadbalancer-hostname annotation to the loadbalncer pointing the domain name, this is required for certmanger to work propertly.
1. # cert manager with lets encrypt issuer
1. # update my domain records
1. # deploy two sample applications

At this point I prefer to go to my do account and change droplets name to more friendly names , couldn't figureout how to script this step.
# Enable ssh to kubernetes droplets
1. From the do account, Cloud firewall, make sure port 22 is open 
1. use MakeFile to create kubernetes secret of the SSH key
   If you don't have one already, generate both key using 

    > ssh-keygen -t rsa -C "your_email@example.com"
    
1. Apply ssh-enabler.yaml. 

    this is a kubernetes DaemonSet, therfore runs a pod on each instance in the cluster. The daemonset mounts the .shh folder of the droplet inside the pod. Just after the pod starts it appends the key from the kubernetes secret to Authorized file inside .ssh folder which maps to the dropltes. The second command is just sleep for some time to allow for deleting the DaemonSet before it restarts and appends the key again.
