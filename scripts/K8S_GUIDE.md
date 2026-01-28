# Kubernetes Installation Guide (Manual SSH Steps)

Follow these steps once your EC2 instances are provisioned.

## 1. On ALL Nodes (Master & Workers)
Run the installation script to set up prerequisites:
```bash
# Upload and run the script
sudo bash install-k8s.sh
```

## 2. On the MASTER Node Only
Initialize the cluster:
```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

Configure your local user to manage the cluster:
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Install the Network Plugin (Flannel):
```bash
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
```

## 3. On BOTH WORKER Nodes
Use the join command provided at the end of the `kubeadm init` output on the master. It looks like this:
```bash
sudo kubeadm join <MASTER_IP>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>
```

## 4. Validation (On Master)
Check the status of the nodes:
```bash
kubectl get nodes
```
Wait until all nodes are in **Ready** status.
