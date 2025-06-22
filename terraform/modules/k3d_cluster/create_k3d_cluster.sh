#!/usr/bin/env bash
set -eux

CLUSTER_NAME="$1"
AGENT_COUNT="$2"
# STORAGE_PATH is ignored for ephemeral clusters

# delete any existing k3d cluster
if k3d cluster list --no-headers | awk '{print $1}' | grep -x "$CLUSTER_NAME"; then
  k3d cluster delete "$CLUSTER_NAME"
fi

# create new cluster: 1 control-plane + N workers, NO persistent storage
k3d cluster create "$CLUSTER_NAME" \
  --servers 1 \
  --agents "$AGENT_COUNT" \
  -p "80:80@loadbalancer" \
  -p "443:443@loadbalancer" \
  --timeout 5m \
  --wait
