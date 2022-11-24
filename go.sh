## SETUP VM FOR CONTAINERIZED APP DEVELOPMENT
# start creation of a vm with vagrant
vagrant up
# destroy the vm
vagrant destroy
# log in
vagrant ssh
# run (kubectl-commands) as super user
sudo su
# bootstrapping a cluster with k3s on the VM
curl -sfL https://get.k3s.io | sh -
# check that k3s is running
kubectl get node # should give NAME = localhost, Status = Ready, ROLES = control-plane, master, AGE and VERSION
# Get the configuration of the cluster (in the case of k3s!)
cat /etc/rancher/k3s/k3s.yaml
# Configure your own machine to talk to this cluster by finding the config file
# under [user-name].kube. Paste the output of the command above into this file.
# Then, use port-fowaring of the VM to your machine by
# -> opening Virtual Box
# -> select machine and open settings
# -> find network-settings and select "port forwaring"
# -> add the port of the cluster to the list of open ports like HOST:GUEST = 6441:6441
# You can talk to the cluster now "on the machine" and "from your machine"!
# Get the control plane and add-ons endpoints
kubectl cluster-info
# Get all the nodes in the cluster
kubectl get nodes
# Get extra details about the nodes, including  internal IP
kubectl get nodes -o wide
# Get all the configuration details about the node, including the allocated pod CIDR
## DEPLOYMENT OF APPLICATION
# Assuming you are inside the Vagrant VM
# Replace the image path, as applicable to you, for e.g, pixelpotato/go-helloworld:v1.0.0
kubectl create deploy go-helloworld --image=sudkul/go-helloworld:v1.0.0
# Get the details
kubectl get deploy,rs,svc,pods
# Copy the pod name from above and Port forward the pod, this is not for use in practice.
# To expose a container, we usually use a service called "expose" (see below)
kubectl port-forward pod/go-helloworld-fcd468f98-rsj7p --address 0.0.0.0 6111:6111
# To delete a deployment copy the deployment name from above and
kubectl delete deploy/<deployment_name>
# expose the `go-helloworld` deployment on port 8111
# note: the application is serving requests on port 6112
kubectl expose deploy go-helloworld --port=8111 --target-port=6112
## CONFIGMAPS, SECRETS AND NAMESPACES
# Create some kind of environment variable in the cluster termed config-map
kubectl create configmap testconfigmap --from-literal=color=yellow
# generate a secret, e.g. to store credentials for log-ins. Note these are coded
kubectl create secret generic testsecret --from-literal=color=blue
# create a namespace containers reside in for better filtering, e.g. TEST, PROD, SANDBOX
# create a `sandbox` Namespace
kubectl create ns sandbox
# get all namespaces
kubectl get ns
# get all the pods in the `sandbox` Namespace
kubectl get po -n sandbox
# create a resource in a namespace, e.g. sandbox
kubectl create deploy [...] -ns sandbox
## DECLARATIVE WAY OF WORKING
# create a resource defined in the YAML manifests with the name mymanifest.yaml
kubectl apply -f mymanifest.yaml
# create the yaml for an object, in gneeral kubectl create RESOURCE [REQUIRED FLAGS] --dry-run=client -o yaml
# get the base YAML templated for a demo Deployment running a nxing application
kubectl create deploy demo --image=nginx --dry-run=client -o yaml
# ...with piping into a file
kubectl create deploy go-helloworld --image=sudkul/go-helloworld:v1.0.0 --dry-run=client -o yaml > manifest.yaml
# delete a resource defined in the YAML manifests with the name mymanifest.yaml
kubectl delete -f mymanifest.yaml
# ARGO-CI SETUP, taken from https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd
# Installing
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# Exposing must be done for node argocd-server
kubectl port-forward svc/argocd-server -n argocd 8080:443
# Gt the password for login, then use admin + passowrd to login
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
