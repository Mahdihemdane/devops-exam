# Phase 4 Guide: GitOps, Argo CD & DuckDNS

## 1. DuckDNS Configuration
You must configure your DuckDNS domain to point to your Master Node's public IP.

- **Domain**: `devops-exam.duckdns.org`
- **IP**: `18.209.112.201`
- **Application Port (HTTP)**: `31644`
- **Application Port (HTTPS)**: `32269`
- **Note**: Since this is a bare-metal Kubernetes installation, you access your app at `http://devops-exam.duckdns.org:31644`.

## 2. Accessing Argo CD
Argo CD is exposed via a **NodePort** on the Master Node.

- **URL**: `https://18.209.112.201:31061` 
- **Username**: `admin`
- **Password**: `exziaxNKkMtamxXs`

## 3. GitOps Workflow
I have created the Kubernetes manifests in the `k8s/` directory:
- `k8s/argocd-app.yaml`: The Argo CD Application definition.
- `k8s/frontend/manifests.yaml`: The Deployment (image `1.0.0`), Service, and Ingress for your app.

### To deploy:
1.  **Commit and Push** your changes to the `main` branch:
    ```powershell
    git add .
    git commit -m "Add GitOps manifests and .gitignore"
    git push origin main
    ```
2.  **Apply the Argo CD Application**:
    ```powershell
    ssh -i labsuser.pem ubuntu@18.209.112.201 "kubectl apply -f k8s/argocd-app.yaml"
    ```
3.  Argo CD will then automatically sync and deploy your application to the `examen-26` namespace.

## 4. Troubleshooting & Verification
- Check Argo CD Pods: `kubectl get pods -n argocd`
- Check App Pods: `kubectl get pods -n examen-26`
- Check Ingress: `kubectl get ingress -n examen-26`
