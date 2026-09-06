## NOTE related to helm
helm create nginx-chart
helm install nginx-release nginx-chart

# list all of your release
helm list
kubectl get svc
kubectl get pod

# values.yml inside the nginx-chart directory
helm upgrade nginx-release nginx-chart
helm upgrade nginx-release nginx-chart
helm history nginx-release 
helm rollback nginx-release <revision-id>

# render the manifest values of the chart
helm install springboot-prod springboot-helm-chart --values prod-values.yaml