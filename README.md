# Local Kubernetes Cluster with Rancher

This project creates a local Kubernetes cluster using [k3d](https://k3d.io/) and installs Rancher via Terraform. The cluster is intended for local testing and evaluation.

## Prerequisites

- [Terraform](https://www.terraform.io/) >= 1.1
- [k3d](https://k3d.io/) installed on your machine
- `kubectl` available in your `$PATH`

## Usage

1. Clone the repository and change into the `terraform` directory:

```bash
cd terraform
```

2. Initialize Terraform:

```bash
terraform init
```

3. Apply the configuration, setting a Rancher admin password:

```bash
terraform apply -var="rancher_admin_password=<choose-a-password>"
```

4. After the apply completes, merge the kubeconfig:

```bash
k3d kubeconfig merge rancher-test --switch
```

5. Access the Rancher UI at `https://localhost:8443` and log in with the password you provided.

6. When you are done, destroy the environment:

```bash
terraform destroy
```
