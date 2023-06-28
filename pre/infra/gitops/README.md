# Optty GitOps

[![pipeline status](https://gitlab.com/deimosdev/client-project/optty/gitops/badges/master/pipeline.svg)](https://gitlab.com/deimosdev/client-project/optty/gitops/-/commits/master)

This project contains scripts and instructions to manage kubernetes resource dependencies for the Optty Project.

### Requirements
- Argocd > 1.7.10 (installed on the kubernetes cluster)
- kustomize
- helm

### Environments
- [staging](./staging/)
- [production](./production)

To apply, `kubectl apply argocd/argocd.yaml` to create the resources for each environment

## Applications

### Namespace
- Creates namespaces for various applications: `nats-io`: for nats, `internal-system` for running resources not related to any service, `apps-staging` for staging applications and `apps` for the dev applications
- Includes annotations for linkerd injection and skip-outbound-ports to prevent linkerd interfering with connections to such applications. Ports to be skipped by linkerd:
    - sql (3306)
    - nats (4222)
    - redis 6379
### [Cert Manager](https://cert-manager.io/)
- Install Cert-Manager from Helm charts
- Create lets-encrypt and self-signed issuer

### [Linkerd](https://github.com/linkerd/linkerd2/)
- Automate the Linkerd control plane install and upgrade lifecycle using Argo CD
- Incorporate Linkerd auto proxy injection feature into the GitOps workflow to auto mesh applications
- Securely store the mTLS trust anchor key/cert with offline encryption and runtime auto-decryption using sealed-secrets
- Use cert-manager to manage the mTLS issuer key/cert resources
- Utilize Argo CD projects to manage bootstrap dependencies and limit access to servers, namespaces and resources
- Uses Argo CD app of apps pattern to declaratively manage a group of application

### [Nats Operator](https://github.com/nats-io/nats-operator)
- Setup Nats Operator to create Nats server
- Automate Nats User Management using `ServiceAccount` and `NatsServiceRole` which creates `bound-token` secrets that can be used as passwords

### [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets)
- Install Sealed Secrets to allow creation of encrypted secrets that can be committed to version control
