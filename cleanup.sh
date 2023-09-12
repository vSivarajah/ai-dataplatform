#!/bin/bash

# Function to delete a kind cluster if it exists
delete_cluster_if_exists() {
  local cluster_name=$1
  if kind get clusters | grep -q "$cluster_name"; then
    echo "Deleting $cluster_name cluster..."
    kind delete cluster --name "$cluster_name"
  else
    echo "$cluster_name cluster does not exist. Skipping deletion."
  fi
}

# Delete staging cluster if it exists
delete_cluster_if_exists "staging"

# Delete production cluster if it exists
delete_cluster_if_exists "production"

echo "Cleanup complete."
