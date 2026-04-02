#!/usr/bin/env bash

set -euo pipefail

TALOSCONFIG=$(mktemp)
trap 'rm -rf $TALOSCONFIG' EXIT

# configuration from terraform provider
echo '${talosconfig}' > $TALOSCONFIG
export TALOSCONFIG

# node ips from terraform
CONTROLPLANE_IP="${controlplane_ip}"
W1_IP="${worker1_ip}"
W2_IP="${worker2_ip}"

echo "=========================================="
echo "Talos Cluster Bootstrap (Static IPs)"
echo "=========================================="
echo "Control Plane: $CONTROLPLANE_IP"
echo "Worker 1:      $W1_IP"
echo "Worker 2:      $W2_IP"
echo ""

wait_for_talos_node() {
    local ip=$1
    local name=$2

    echo "waiting for node $name ($ip) to reach maintenance mode ..."
    until curl -sk "https://$ip:50000" > /dev/null 2>&1; do
        echo "  $name not ready yet ..."
        sleep 5
    done
    echo "  $name is ready"
}

wait_for_k8s_api() {
    local ip=$1

    echo "waiting for k8s API on $ip:6443 to be available ..."
    until curl -sk "https://$ip:6443" > /dev/null 2>&1; do
        echo "  k8s API not ready yet ..."
        sleep 5
    done
    echo "  k8s API is ready"
}

wait_for_talos_node "$CONTROLPLANE_IP" "Control Plane"

echo ""
echo "Applying node configuration to Control Plane ..."
talosctl apply-config \
    --nodes "$CONTROLPLANE_IP" \
    --insecure \
    --file <(echo '${controlplane_config}' | base64 -d)

echo "Waiting for etcd to become ready to bootstrap ..."
sleep 30

wait_for_k8s_api "CONTROLPLANE_IP"

echo ""
echo "Bootstrapping etcd ..."
talosctl bootstrap \
    --nodes "$CONTROLPLANE_IP" \
    --endpoints "$CONTROLPLANE_IP"

echo "Waiting for Control Plane to stabilize ..."
sleep 30

wait_for_talos "$W1_IP" "Worker 1"

echo ""
echo "Applying configuration to worker node 1 ..."
talosctl apply-config \
  --nodes "$W1_IP" \
  --insecure \
  --file <(echo '${worker1_config}' | base64 -d)

# Worker 2
wait_for_talos "$W2_IP" "Worker 2"

echo ""
echo "Applying configuration to worker node 2 ..."
talosctl apply-config \
  --nodes "$W2_IP" \
  --insecure \
  --file <(echo '${worker2_config}' | base64 -d)


echo ""
echo "Waiting for cluster health check ..."
sleep 30

talosctl health \
  --nodes "$CP_IP" \
  --endpoints "$CP_IP" \
  --wait-timeout 300s || echo "Health check incomplete, cluster may still be initializing"

echo ""
echo "Retrieving kubeconfig ..."
talosctl kubeconfig \
  --nodes "$CP_IP" \
  --endpoints "$CP_IP" \
  ./kubeconfig

echo ""
echo "=========================================="
echo "Bootstrap Complete!"
echo "=========================================="
echo "Kubeconfig saved to: ./kubeconfig"
echo "Talosconfig saved to: ./talosconfig"
echo ""
echo "Next steps:"
echo "  export KUBECONFIG=$(pwd)/kubeconfig"
echo "  kubectl get nodes"
