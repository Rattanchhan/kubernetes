# Kubernetes Deployment Strategies Lab

A hands-on lab for practicing Kubernetes deployment strategies using your
existing React and Spring Boot Docker images.

Included strategies:

- Recreate
- RollingUpdate
- Blue/Green
- Canary using pod-ratio traffic approximation

PostgreSQL is shared by all strategy exercises so the focus stays on application
deployment behavior.

## 1. Requirements

- A working Kubernetes cluster
- kubectl configured
- Your React Docker image
- Your Spring Boot Docker image
- Images must be pullable by the cluster

Check:

```bash
kubectl get nodes
```

## 2. Configure

Edit:

```bash
nano config.env
```

At minimum replace:

```bash
SPRINGBOOT_IMAGE=CHANGE_ME_SPRINGBOOT_IMAGE:latest
REACT_IMAGE=CHANGE_ME_REACT_IMAGE:latest
```

Example:

```bash
SPRINGBOOT_IMAGE=ratanachhan/account-service:latest
REACT_IMAGE=ratanachhan/react-app:latest
```

Also adjust ports and database values to match your application.

## 3. Important Spring Boot configuration

The lab exposes these variables:

```text
DB_HOST=postgres-service
DB_PORT=5432
DB_NAME=<config.env>
DB_USER=<config.env>
DB_PASSWORD=<config.env>
SPRING_PROFILES_ACTIVE=<config.env>
```

If your Spring Boot application uses different environment variable names,
edit:

```text
backend/springboot-configmap.yaml.tpl
backend/springboot-secret.yaml.tpl
```

For example, your application may instead require:

```text
SPRING_DATASOURCE_URL
SPRING_DATASOURCE_USERNAME
SPRING_DATASOURCE_PASSWORD
```

You can replace the provided environment variables accordingly.

## 4. Generate YAML

```bash
chmod +x scripts/*.sh
./scripts/configure.sh
```

Rendered manifests appear under:

```text
generated/
```

Do not edit generated files permanently. Edit the `.tpl` source files and rerun
`configure.sh`.

## 5. Recreate Strategy

Deploy:

```bash
./scripts/apply-recreate.sh
```

Watch pods:

```bash
kubectl get pods -n bank-app -w
```

In another terminal trigger a new release by changing RELEASE_VERSION:

```bash
kubectl set env deployment/springboot-recreate \
  RELEASE_VERSION=v2 \
  -n bank-app

kubectl set env deployment/react-recreate \
  RELEASE_VERSION=v2 \
  -n bank-app
```

Expected behavior:

```text
Old pods terminate
        ↓
temporary capacity gap / possible downtime
        ↓
new pods start
```

Check:

```bash
kubectl describe deployment springboot-recreate -n bank-app
```

## 6. RollingUpdate Strategy

Cleanup the strategy deployments first if desired:

```bash
kubectl delete deployment springboot-recreate react-recreate -n bank-app
kubectl delete service springboot-recreate-service react-recreate-service -n bank-app
```

Deploy:

```bash
./scripts/apply-rolling.sh
```

Watch:

```bash
kubectl get pods -n bank-app -w
```

Trigger:

```bash
kubectl set env deployment/springboot-rolling \
  RELEASE_VERSION=v2 \
  -n bank-app

kubectl set env deployment/react-rolling \
  RELEASE_VERSION=v2 \
  -n bank-app
```

Configured as:

```yaml
maxSurge: 1
maxUnavailable: 0
```

Expected:

```text
old pods + new pod overlap
          ↓
new pod becomes available
          ↓
old pod terminates
          ↓
repeat
```

## 7. Blue/Green Strategy

Deploy:

```bash
./scripts/apply-blue-green.sh
```

Both versions run simultaneously:

```text
springboot-blue
springboot-green

react-blue
react-green
```

Initially the Services route to BLUE.

Verify:

```bash
kubectl get svc springboot-bluegreen-service \
  -n bank-app \
  -o jsonpath='{.spec.selector}'

echo
```

Switch to GREEN:

```bash
./scripts/switch-bluegreen-to-green.sh
```

Rollback to BLUE:

```bash
./scripts/switch-bluegreen-to-blue.sh
```

This demonstrates the central Blue/Green idea:

```text
Deployment stays running
Service selector chooses active environment
```

## 8. Canary Strategy

Deploy:

```bash
./scripts/apply-canary.sh
```

The example uses:

```text
stable replicas = 4
canary replicas = 1
```

Both have the same service label:

```text
app=springboot-canary
```

Therefore the Service can distribute requests across all five pods.

This gives an approximate pod-ratio:

```text
Stable ≈ 80%
Canary ≈ 20%
```

This is only a learning example. Kubernetes Service does not guarantee precise
percentage-based traffic weights.

Production canary deployments commonly use tools such as:

- Argo Rollouts
- Istio
- NGINX Ingress canary annotations
- Gateway API implementations

## 9. Access applications without Ingress

Because this lab focuses on deployment strategies, Services are ClusterIP.

Spring Boot example:

```bash
kubectl port-forward \
  service/springboot-recreate-service \
  9024:9024 \
  -n bank-app
```

React example:

```bash
kubectl port-forward \
  service/react-recreate-service \
  8080:80 \
  -n bank-app
```

Then access:

```text
React:       http://localhost:8080
Spring Boot: http://localhost:9024
```

Use the service names that correspond to the strategy you are currently testing.

## 10. Useful commands

```bash
kubectl get all -n bank-app

kubectl get pods -n bank-app -o wide

kubectl get deployments -n bank-app

kubectl get replicasets -n bank-app

kubectl describe deployment <deployment-name> -n bank-app

kubectl rollout status deployment/<deployment-name> -n bank-app

kubectl rollout history deployment/<deployment-name> -n bank-app
```

## 11. Clean everything

```bash
./scripts/cleanup.sh
```

This deletes the entire lab namespace, including the PostgreSQL PVC.

## Directory Structure

```text
k8s-deployment-strategies-lab/
├── config.env
├── namespace.yaml.tpl
├── README.md
├── postgres/
│   ├── postgres-secret.yaml.tpl
│   ├── postgres-pvc.yaml.tpl
│   ├── postgres-deployment.yaml.tpl
│   └── postgres-service.yaml.tpl
├── backend/
│   ├── springboot-configmap.yaml.tpl
│   ├── springboot-secret.yaml.tpl
│   ├── springboot-deployment.yaml.tpl
│   └── springboot-service.yaml.tpl
├── frontend/
│   ├── react-deployment.yaml.tpl
│   └── react-service.yaml.tpl
├── strategies/
│   ├── recreate/
│   ├── rolling-update/
│   ├── blue-green/
│   └── canary/
├── scripts/
│   ├── configure.sh
│   ├── apply-base.sh
│   ├── apply-recreate.sh
│   ├── apply-rolling.sh
│   ├── apply-blue-green.sh
│   ├── apply-canary.sh
│   ├── switch-bluegreen-to-green.sh
│   ├── switch-bluegreen-to-blue.sh
│   └── cleanup.sh
└── generated/
```

## Suggested learning order

```text
Recreate
   ↓
RollingUpdate
   ↓
Blue/Green
   ↓
Canary
```

Do not introduce Ingress, Helm, Argo CD, or advanced database migration logic
until you are comfortable observing the behavior of these four strategies.
