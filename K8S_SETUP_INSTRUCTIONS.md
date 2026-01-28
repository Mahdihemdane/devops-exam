# Kubernetes Cluster Setup Instructions

## Current Infrastructure
- **Master Node**: `18.209.112.201` (master-node)
- **Worker Node 1**: `35.173.185.126` (worker-node-1)
- **Worker Node 2**: `34.227.99.52` (worker-node-2)
- **SSH Key**: `labsuser.pem` (private key)

---

## Prerequisites
Ensure the SSH key has correct permissions:
```powershell
# On Windows PowerShell
icacls labsuser.pem /inheritance:r
icacls labsuser.pem /grant:r "$($env:USERNAME):(R)"
```

---

## Step 1: Install Kubernetes on All Nodes

### Upload installation script to all nodes:
```powershell
# Master node
scp -i labsuser.pem scripts/install-k8s.sh ubuntu@18.209.112.201:~/

# Worker node 1
scp -i labsuser.pem scripts/install-k8s.sh ubuntu@35.173.185.126:~/

# Worker node 2
scp -i labsuser.pem scripts/install-k8s.sh ubuntu@34.227.99.52:~/
```

### Run installation on all nodes:
```powershell
# Master node
ssh -i labsuser.pem ubuntu@18.209.112.201 "chmod +x ~/install-k8s.sh && sudo bash ~/install-k8s.sh"

# Worker node 1
ssh -i labsuser.pem ubuntu@35.173.185.126 "chmod +x ~/install-k8s.sh && sudo bash ~/install-k8s.sh"

# Worker node 2
ssh -i labsuser.pem ubuntu@34.227.99.52 "chmod +x ~/install-k8s.sh && sudo bash ~/install-k8s.sh"
```

---

## Step 2: Initialize Master Node

### SSH into master:
```powershell
ssh -i labsuser.pem ubuntu@18.209.112.201
```

### Initialize Kubernetes cluster:
```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

**Important**: Save the `kubeadm join` command from the output. It will look like:
```bash
kubeadm join 18.209.112.201:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>
```

### Configure kubectl:
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### Install Flannel network plugin:
```bash
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
```

### Verify master is ready:
```bash
kubectl get nodes
```

---

## Step 3: Join Worker Nodes

### SSH into Worker Node 1:
```powershell
ssh -i labsuser.pem ubuntu@35.173.185.126
```

### Run the join command (use the one from Step 2):
```bash
sudo kubeadm join 18.209.112.201:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>
```

### Exit and repeat for Worker Node 2:
```powershell
exit
ssh -i labsuser.pem ubuntu@34.227.99.52
```

```bash
sudo kubeadm join 18.209.112.201:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>
```

---

## Step 4: Verify Cluster

### SSH back to master:
```powershell
ssh -i labsuser.pem ubuntu@18.209.112.201
```

### Check all nodes:
```bash
kubectl get nodes
```

You should see all 3 nodes in **Ready** status:
```
NAME                STATUS   ROLES           AGE   VERSION
master-node         Ready    control-plane   5m    v1.31.x
worker-node-1       Ready    <none>          2m    v1.31.x
worker-node-2       Ready    <none>          2m    v1.31.x
```
