#!/bin/bash
set -e

echo "🔨 Building Docker image..."

# Ensure using Minikube's Docker daemon
eval $(minikube docker-env)

# Build new version
VERSION=$(date +%Y%m%d-%H%M%S)
docker build -t nodejs-shopping:$VERSION .
docker tag nodejs-shopping:$VERSION nodejs-shopping:latest

echo "✅ Built nodejs-shopping:$VERSION"

echo "🚀 Updating Kubernetes deployment..."

# Update deployment image
kubectl set image deployment/nodejs-app \
  nodejs-app=nodejs-shopping:$VERSION \
  -n app

# Wait for rollout
kubectl rollout status deployment/nodejs-app -n app

echo "✅ Deployment complete!"


# Show pods
kubectl get pods -n app
