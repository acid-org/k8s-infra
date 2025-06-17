# Local Kubernetes Cluster with Rancher

This project creates a local Kubernetes cluster using [k3d](https://k3d.io/) and installs Rancher via Terraform. The cluster is managed through the [pvotal-tech k3d provider](https://registry.terraform.io/providers/pvotal-tech/k3d/latest) and is intended for local testing and evaluation.

The Terraform configuration is structured using reusable modules located under `terraform/modules` to keep the codebase organized.

## Prerequisites

- [Terraform](https://www.terraform.io/) >= 1.1
- [k3d](https://k3d.io/) installed on your machine
- `kubectl` available in your `$PATH`
- [Flux CLI](https://fluxcd.io/docs/installation/) available in your `$PATH`

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
   and then deploys Rancher. Set a Rancher admin password and optionally
   specify a hostname for the Rancher ingress (defaults to `rancher.local`).
   The `cluster_name` and `agent_count` variables can be used to
   customize the k3d cluster name and number of agent nodes. The
   `storage_path` variable specifies a host directory used to persist
   cluster data (defaults to `/media/acid/windows`):

```bash
terraform apply \
  -var="rancher_admin_password=<choose-a-password>" \
  -var="rancher_hostname=<your-hostname>" \
  -var="cluster_name=<cluster-name>" \
  -var="agent_count=<number-of-agents>" \
  -var="storage_path=<host-storage-directory>"
```

4. After the apply completes, merge the kubeconfig so `kubectl` can reach
   the new cluster:

```bash
k3d kubeconfig merge rancher-test --switch
```

5. Add an entry for `rancher.local` pointing to `127.0.0.1` in your
   `/etc/hosts` file and access the Rancher UI at `https://rancher.local`.

6. When you are done, destroy the environment:

```bash
terraform destroy
```

## Bootstrapping Flux

1. Install the Flux CLI following the [official instructions](https://fluxcd.io/docs/installation/).
1. Set the variables `flux_git_repository_url` and `flux_git_repository_branch` in `terraform.tfvars` or via the CLI. Point them at your `k8s-workloads` repository and branch.
   Provide a GitHub token via the `flux_github_token` variable so Flux can push manifests during bootstrapping.
2. Run `terraform apply` after the Rancher installation completes. A `null_resource` will invoke `flux bootstrap git` to configure Flux to watch the specified repository.
   The bootstrap command runs with `TMPDIR=/tmp/fluxcd`. The token is exported as `GIT_PASSWORD` and Flux is invoked with `--token-auth --username=git` so it can clone your repository and push manifests without prompting.
3. Commit Kubernetes manifests to the `k8s-workloads` repository and Flux will sync them into the cluster.

Flux manages workload deployment entirely from the watched Git repository.

