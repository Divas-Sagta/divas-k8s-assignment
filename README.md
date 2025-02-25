# divas-k8s-assignment

![image](https://github.com/user-attachments/assets/7ddbd800-ae50-4a95-adc7-c567d2392ec0)

![image](https://github.com/user-attachments/assets/da68ff25-7cbe-4137-a300-d1d861aae7f4)

![image](https://github.com/user-attachments/assets/e393f30a-cb67-43c1-a39e-492431d163cf)

![image](https://github.com/user-attachments/assets/4729c91d-14c4-476a-8ed1-0d4373ad82ab)


# Kubernetes Deployment on Amazon EKS with Persistent Volume

## Overview
This repository contains Kubernetes manifests for deploying an application on **Amazon EKS** with **Persistent Volumes (PV)**. The configuration files are stored in the `kube/` directory and include resources such as:
- **ConfigMap**
- **Service**
- **Persistent Volume Claim (PVC)**
- **StorageClass**
- **Deployment**
- **Ingress**

## Prerequisites
Ensure you have the following tools installed:
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [eksctl](https://eksctl.io/)
- [AWS CLI](https://aws.amazon.com/cli/)
- [Helm](https://helm.sh/docs/intro/install/)

## Deploying to Amazon EKS

### 1. Create an EKS Cluster
```sh
eksctl create cluster \
  --name divas-cluster \
  --region <aws-region> \
  --nodegroup-name standard-workers \
  --node-type t3.medium \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 3 \
  --managed
```

### 2. Configure kubectl
```sh
aws eks update-kubeconfig --name divas-cluster --region <aws-region>
kubectl get nodes  # Verify cluster is running
```

### 3. Apply Storage Class & Persistent Volume Claim (PVC)
```sh
kubectl apply -f kube/storageclass.yaml
kubectl apply -f kube/pvc.yaml
```

### 4. Deploy ConfigMap, Services, and Deployment
```sh
kubectl apply -f kube/configmap.yaml
kubectl apply -f kube/service.yaml
kubectl apply -f kube/deployment.yaml
```

### 5. Deploy Ingress (Optional - Requires ALB Controller)
```sh
kubectl apply -f kube/ingress.yaml
```

## Verifying Deployment
- Check running pods:
  ```sh
  kubectl get pods -n default
  ```
- Check services:
  ```sh
  kubectl get svc
  ```
- Describe Persistent Volume:
  ```sh
  kubectl describe pvc <pvc-name>
  ```

## Cleanup Resources
To delete the deployment and the cluster:
```sh
kubectl delete -f kube/
eksctl delete cluster --name divas-cluster --region <aws-region>
```

## Conclusion
This project deploys a **Kubernetes application** on **Amazon EKS** with **persistent storage** using EBS-backed Persistent Volumes. Ingress is set up for external access, and Helm can be used to deploy additional services like monitoring and logging.





