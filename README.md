# Overview
This repository contains terraform scripts to provision an EKS cluster with an encrypted EFS filesystem along with a sample application to test mounting an encrypted EFS share into a kubernetes POD

## Install an EKS cluster
First install an EKS cluster with everything configured to mount an Encrypted EFS volument into POD. Terraform scripts in this repo does just that. Follow steps below to get EKS and all necessary infra pieces up and running in your AWS account.

Assuming you have logged in with your credentials into your AWS account run commands below
```
terraform init
terraform plan
terraform apply
```

Grab the EFS file system id that will be displayed in output after terraform apply is successfully completed. This is the identifier for the EFS file system that gets created. Update the fileSystemId parameter in included storage class resource yaml file under k8s directory (sc.yaml) with the values from the output. You can also get the id by logging into AWS console and navigating to EFS.

Create the storage class by running the command below 
```
kubectl apply -f deploy/k8s/sc.yaml
```
Deploy sample pod that demonstrates mounting EFS volume. 
```
kubectl apply -f deploy/k8s/pod.yaml
```
