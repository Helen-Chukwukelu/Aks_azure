# (K8) Kubernetes Configurations scripts 

### Requirements
# Install ansible k8 plugins

We use this plugin for the ansible scripts to function correctly 
```sh
ansible-galaxy collection install community.kubernetes
```

Then install the required Python modules
```sh
pip3 install PyYAML openshift kubernetes --user
```


## ingress-nginx

Note: The YML is version specific 

The YML file use was downloaded from here:
https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.48.1/deploy/static/provider/cloud/deploy.yaml


# Install K8 Configurations
```sh
cd ansible/k8_configurations/
ansible-playbook k8_configs.yml 
```