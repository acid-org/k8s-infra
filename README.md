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

3. Apply the configuration. Terraform installs cert-manager automatically
   and then deploys Rancher. Set a Rancher admin password:

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

## Bootstrapping Flux

1. Set the variables `flux_git_repository_url` and `flux_git_repository_branch` in `terraform.tfvars` or via the CLI. Point them at your `k8s-workloads` repository and branch.
2. Run `terraform apply` after the Rancher installation completes. A `null_resource` will invoke `flux install` to configure Flux to watch the specified repository.
3. Commit Kubernetes manifests to the `k8s-workloads` repository and Flux will sync them into the cluster.

Flux manages workload deployment entirely from the watched Git repository.

