apiVersion: apps/v1
kind: Deployment
metadata:
  name: springboot-recreate
  namespace: __NAMESPACE__
spec:
  replicas: 2
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: springboot-recreate
  template:
    metadata:
      labels:
        app: springboot-recreate
    spec:
      containers:
        - name: springboot
          image: __SPRINGBOOT_IMAGE__
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: __SPRINGBOOT_PORT__
          envFrom:
            - configMapRef:
                name: springboot-config
            - secretRef:
                name: springboot-secret
          env:
            - name: RELEASE_VERSION
              value: "v1"
---
apiVersion: v1
kind: Service
metadata:
  name: springboot-recreate-service
  namespace: __NAMESPACE__
spec:
  selector:
    app: springboot-recreate
  ports:
    - port: __SPRINGBOOT_PORT__
      targetPort: __SPRINGBOOT_PORT__
