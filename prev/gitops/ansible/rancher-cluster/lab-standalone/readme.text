# Prepare
Make sure all hosts have the Bastion / JumpBox ssh keys deployed for password less ssh

Download RKE (Rancher) - Rancher Kubernetes Engine (RKE) is a CNCF-certified Kubernetes distribution that runs entirely within Docker containers
wget https://github.com/rancher/rke/releases/download/v1.2.12/rke_linux-amd64
mv rke_linux-amd64 rke && chmod +x rke
sudo mv rke /usr/local/bin/

# Download Kube Control on Bastion / JumpBox
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Test Connectivity 
# all should be green in status
ansible all -i inventory.yml  -m ping

# Deploy Docker to all required hosts for RKE
ansible-playbook  -i inventory.yml  prepare_ubuntu.yml  -b


# Generate New Config
rke config --name cluster.yml

# Build cluster
rke up

# Install Kube Control Configuration 
mkdir ~/.kube
cp kube_config_cluster.yml ~/.kube/config

kubectl get pods -owide -A
