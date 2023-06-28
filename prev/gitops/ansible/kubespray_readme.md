# Kubespray
## Ansible Kubernetes Builder

### Requirements
* User account with password less SUDO access e.g.; echo 'yoursuser ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/k8sudo
* SSH keys
* net-tools package 
* ubuntu os's- > sudo apt install iputils-ping

### Turnkey Cloud Environments Requirements/Notes
# Google GCP
Make sure that the IPIP protocol is unblocked in the GCP firewall with use of calico

### ALL VM's 
# SSH KEYS
You need to setup SSH keys to all the nodes from your control/bastion/jumpbox/laptop
This can be done by
* Generating the SSH keys
* Copying the SSH keys to all nodes

Example:
```sh
ssh-keygen
ssh-copy-id  userwithsudoaccess@ip or dns name
```

## Install Kubespray from Github
You need to git clone the online repository github
```sh
git clone git@bitbucket.org:prevoirsolutionsinformatiques/gitops.git
cd kubespray/
pip install -r requirements.txt

# create your own config set
cp -r inventory/sample inventory/insightv2

# declare all the ips of your cluster
declare -a IPS=(10.168.1.111 10.168.1.112 10.168.1.113 10.168.1.114 10.168.1.115 10.168.1.116)
CONFIG_FILE=inventory/insightv2/hosts.yml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

# Configure Ansible Hostnnames and IPs
modify -> hosts.yml with YOUR hostnames and IP address

** NOTICE: The host names in hosts.yml directly affects how the cluster will name your K8 nodes **

customize as needed your group vars located under `inventory/insightv2/group_vars`
```

## Install Kubespray from 4C Repo
If using our bitbucket repo then you can use the pre-defined template called insightv2 located under `gitops/ansible/kubespray/inventory/insightv2`

  
## Run the playbook

Before you run the playbook confirm the SSH connectivity is working
```sh
ansible all -i inventory/insightv2/hosts.yml -m ping
```

```sh
# Do Cluster setup estimated time +-23 min
ansible-playbook -i inventory/insightv2/hosts.yml cluster.yml -b
```

 

 ## Other
 # Reset installation
 This wil clear your installation 
 ```sh
 ansible-playbook -i inventory/insightv2/hosts.yml --become --become-user=root reset.yml
 ```