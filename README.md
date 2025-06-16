# Kubernetes Infrastructure

This repository contains Terraform code for provisioning Kubernetes
infrastructure. After Rancher is installed, Terraform uses a
`null_resource` to install FluxCD which is responsible for deploying
workloads from the `k8s-workloads` Git repository.

## Bootstrapping Flux

1. Set the variables `flux_git_repository_url` and
   `flux_git_repository_branch` in `terraform.tfvars` or via the CLI.
   Point them at your `k8s-workloads` repository and branch.
2. Run `terraform apply` after the Rancher installation has completed.
   The `flux install` command will run automatically and configure Flux
   to watch the provided repository.
3. Commit your Kubernetes manifests to the `k8s-workloads` repository.
   Flux will automatically sync them to the cluster.

Workloads are managed entirely from the `k8s-workloads` repository so
you can control deployments through Git.
