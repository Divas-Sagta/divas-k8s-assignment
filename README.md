# divas-k8s-assignment

![image](https://github.com/user-attachments/assets/7ddbd800-ae50-4a95-adc7-c567d2392ec0)

![image](https://github.com/user-attachments/assets/da68ff25-7cbe-4137-a300-d1d861aae7f4)

![image](https://github.com/user-attachments/assets/e393f30a-cb67-43c1-a39e-492431d163cf)

![image](https://github.com/user-attachments/assets/4729c91d-14c4-476a-8ed1-0d4373ad82ab)



# Kubernetes Deployment on AWS EKS with Persistent Volume

## Overview
This project deploys a Kubernetes application on **Amazon EKS** with **Persistent Volume (PV) and Persistent Volume Claim (PVC)** for data persistence.

## Prerequisites
Before proceeding, ensure you have the following installed:

- AWS CLI ([Install Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html))
- kubectl ([Install Guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/))
- eksctl ([Install Guide](https://eksctl.io/introduction/installation/))
- Helm ([Install Guide](https://helm.sh/docs/intro/install/))
- AWS IAM permissions to create EKS clusters and associated resources

## Clone the Repository
```sh
git clone https://github.com/Divas-Sagta/divas-k8s-assignment.git
cd divas-k8s-assignment
```

---

## Step 1: Create an EKS Cluster
```sh
eksctl create cluster --name divas-cluster --region us-east-1 --nodegroup-name divas-node-group --nodes 2 --nodes-min 1 --nodes-max 3 --managed
```
This command:
- Creates an EKS cluster named `divas-cluster`.
- Deploys it in the `us-east-1` region.
- Creates a managed node group with 2 worker nodes (auto scales between 1 and 3 nodes).

---

## Step 2: Configure Storage with EBS (Elastic Block Store)

### Create a Persistent Volume (PV)
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: ebs-pv
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: gp2
  awsElasticBlockStore:
    volumeID: <YOUR_EBS_VOLUME_ID>
    fsType: ext4
```
**Apply the PV:**
```sh
kubectl apply -f ebs-pv.yaml
```

### Create a Persistent Volume Claim (PVC)
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ebs-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: gp2
```
**Apply the PVC:**
```sh
kubectl apply -f ebs-pvc.yaml
```

---

## Step 3: Deploy the Application

### Deploy the Application with Storage
Modify the `deployment.yaml` file to mount the PVC:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: divas-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: divas-app
  template:
    metadata:
      labels:
        app: divas-app
    spec:
      containers:
      - name: divas-app-container
        image: divas-sagta/divas-app:latest
        volumeMounts:
          - mountPath: "/data"
            name: storage
      volumes:
        - name: storage
          persistentVolumeClaim:
            claimName: ebs-pvc
```
**Apply the Deployment:**
```sh
kubectl apply -f deployment.yaml
```

---

## Step 4: Expose the Application

### Create a Service
```yaml
apiVersion: v1
kind: Service
metadata:
  name: divas-service
spec:
  selector:
    app: divas-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: LoadBalancer
```
**Apply the Service:**
```sh
kubectl apply -f service.yaml
```
This exposes the application using an AWS **Elastic Load Balancer (ELB)**.

---

## Step 5: Verify Deployment
```sh
kubectl get pods
kubectl get svc divas-service
```
Copy the **EXTERNAL-IP** from the `kubectl get svc` output and open it in a browser.

---

## Conclusion
This project sets up an **EKS cluster** with **Persistent Storage (EBS-backed PVC)**, deploys an application, and exposes it using a **LoadBalancer**. 🎯🚀



