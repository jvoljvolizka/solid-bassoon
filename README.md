# Steps to run 

## prerequisites

* terraform
* awscli setup with sufficient permissions
* kubectl

## Initial config

### with s3 backend
- create a s3 bucket
- create a `state.config` file according to the example
```
terraform init -backend-config=./state.config
```

### with local backend
```
echo > backend.tf && terraform init
```

## Infra Deployment
to deploy with default values review with 
```
terraform plan
```
deploy with
```
terraform apply
```
with custom values create a .tfvars file and run 
```
terraform apply -var-file="custom.tfvars"
```

### Kubernetes access
```
aws --profile <profile-name> --region <region-name>  eks update-kubeconfig --name <cluster-name>
```

### Grafana access

Get  grafana endpoint with
```
kubectl get service -n monitoring grafana -o jsonpath={.status.loadBalancer.ingress[0].hostname}
```
Username is admin to get the password run 
```
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

## App Deployment
```
kubectl apply -f ./mock-service/mock-worktest-template.yaml
```

Nginx load balancer endpoint
```
kubectl get ingress worktest-nginx-ingress  -o jsonpath={.status.loadBalancer.ingress[0].hostname}  
```
AWS alb endpoint
```
kubectl get ingress worktest-nginx-ingress  -o jsonpath={.status.loadBalancer.ingress[0].hostname}  
```








