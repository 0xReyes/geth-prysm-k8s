#!/bin/bash

# Generate JWT secret
JWT_SECRET=$(openssl rand -hex 32)
sed "s|jwt.hex: \$(openssl rand -hex 32)|jwt.hex: $JWT_SECRET|" geth-prysm-deployment.yaml > geth-prysm-deployment-generated.yaml

# Apply configuration
kubectl apply -f geth-prysm-deployment-generated.yaml

# Wait for pods to initialize
kubectl wait --for=condition=Ready pod -l app=geth --timeout=5m
kubectl wait --for=condition=Ready pod -l app=prysm-beacon --timeout=5m

# Display status
echo "Geth logs:"
kubectl logs -l app=geth --tail=50

echo -e "\nPrysm logs:"
kubectl logs -l app=prysm-beacon --tail=50