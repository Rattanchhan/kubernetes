apiVersion: apps/v1
kind: Deployment
metadata:
  name: springboot-rolling
  namespace: __NAMESPACE__
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: springboot-rolling
  template:
    metadata:
      labels:
        app: springboot-rolling
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
  name: springboot-rolling-service
  namespace: __NAMESPACE__
spec:
  selector:
    app: springboot-rolling
  ports:
    - port: __SPRINGBOOT_PORT__
      targetPort: __SPRINGBOOT_PORT__
