apiVersion: apps/v1
kind: Deployment
metadata:
  name: springboot-green
  namespace: __NAMESPACE__
spec:
  replicas: 2
  selector:
    matchLabels:
      app: springboot-bg
      version: green
  template:
    metadata:
      labels:
        app: springboot-bg
        version: green
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
              value: "green"
