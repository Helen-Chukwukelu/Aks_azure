# The Deimos Library for Kubernetes

Applications, used by [Deimos](https://deimos.io), ready to launch on Kubernetes using [Kubernetes Helm](https://github.com/helm/helm).

## TL;DR

```bash
$ helm plugin install https://github.com/hayorov/helm-gcs.git
$ helm repo add deimos gs://deimos-helm-templates
$ helm search repo 
$ helm install my-release deimos/<chart>
```

## Before you begin

- Ensure you are authenticated to Google Cloud, either via Gcloud or via `GOOGLE_APPLICATION_CREDENTIALS` variable.
### Prerequisites
- Kubernetes
- Helm 3
- GCS Helm Plugin

### Install Helm

Helm is a tool for managing Kubernetes charts. Charts are packages of pre-configured Kubernetes resources.

To install Helm, refer to the [Helm install guide](https://github.com/helm/helm#install) and ensure that the `helm` binary is in the `PATH` of your shell.

### Install GCS Helm Plugin

helm-gcs is a helm plugin that allows you to manage private helm repositories on Google Cloud Storage aka buckets.

```bash
$ helm plugin install https://github.com/hayorov/helm-gcs.git
```

### Add Repo

The following command allows you to download and install all the charts from this repository:

```bash
$ helm repo add deimos gs://deimos-helm-templates
```

### Using Helm

Once you have installed the Helm client, you can deploy a Bitnami Helm Chart into a Kubernetes cluster.

Please refer to the [Quick Start guide](https://helm.sh/docs/intro/quickstart/) if you wish to get running in just a few commands, otherwise the [Using Helm Guide](https://helm.sh/docs/intro/using_helm/) provides detailed instructions on how to use the Helm client to manage packages on your Kubernetes cluster.

Useful Helm Client Commands:
* View available charts: `helm search repo`
* Install a chart: `helm install my-release deimos/<package-name>`
* Upgrade your application: `helm upgrade`

