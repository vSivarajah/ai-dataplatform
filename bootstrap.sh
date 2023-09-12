#!/bin/bash

# Ensure required environment variables are set
if [ -z "$GITHUB_USER" ] || [ -z "$GITHUB_REPO" ] || [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: Required environment variables (GITHUB_USER, GITHUB_REPO, GITHUB_TOKEN) are not set."
    exit 1
fi


# Create staging cluster if it doesn't exist
if ! kind get clusters | grep -q 'staging'; then
  kind create cluster --name staging
else
  echo "Staging cluster already exists. Skipping creation."
fi

# Create production cluster if it doesn't exist
if ! kind get clusters | grep -q 'production'; then
  kind create cluster --name production
else
  echo "Production cluster already exists. Skipping creation."
fi

# Bootstrap staging
flux bootstrap github \
    --context=kind-staging \
    --owner="$GITHUB_USER" \
    --repository="$GITHUB_REPO" \
    --branch=main \
    --personal \
    --path=clusters/staging

# Bootstrap production
flux bootstrap github \
    --context=kind-production \
    --owner="$GITHUB_USER" \
    --repository="$GITHUB_REPO" \
    --branch=main \
    --personal \
    --path=clusters/production
