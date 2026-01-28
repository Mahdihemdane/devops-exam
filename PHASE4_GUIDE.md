# Phase 4: GitOps & Argo CD - Complete Manual Guide

I have already installed **Argo CD** and the **Nginx Ingress Controller** on your cluster. However, there is a networking conflict on the worker nodes that you need to fix manually for the pods to run.

---

## 1. Fix Networking (Run on Worker Nodes)
The `cni0` bridge on your workers is conflicting with the new cluster network. Run these commands on **both** `worker-node-1` and `worker-node-2`:

```bash
# SSH into workers and run:
sudo ip link set cni0 down
sudo ip link delete cni0
sudo systemctl restart kubelet
```
*Wait 1-2 minutes for the pods to transition to "Running".*

---

## 2. DuckDNS Configuration
Point your DuckDNS domain to your Master IP.

- **Domain**: `devops-exam.duckdns.org`
- **Master IP**: `18.209.112.201`
- **Application Port (HTTP)**: `31644` (Access via `http://devops-exam.duckdns.org:31644`)

---

## 3. Access Argo CD
Argo CD is exposed via a NodePort on the Master Node.

- **URL**: `https://18.209.112.201:31061` (Accept the SSL warning)
- **Username**: `admin`
- **Password**: `exziaxNKkMtamxXs`

---

## 4. GitOps Workflow
I have already created the manifests in the `k8s/` directory.

### Step A: Push to GitHub
Make sure your latest changes are on the `main` branch:
```powershell
# From your local terminal (c:\Users\MahdiHemdane\Desktop\etude + travail\devops)
git add .
git commit -m "Final Phase 4 manifests"
git push origin main
```

### Step B: Apply the Argo CD Application
On the **Master Node**, apply the manifest to start the sync:
```bash
# On Master Node
kubectl apply -f k8s/argocd-app.yaml
```

---

## 5. Final Verification
Check the status of your application:
```bash
# On Master Node
kubectl get pods -n examen-26
kubectl get ingress -n examen-26
```
The application should be reachable at `http://devops-exam.duckdns.org:31644` once the sync is complete.
