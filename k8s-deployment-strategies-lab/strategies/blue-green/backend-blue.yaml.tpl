apiVersion: apps/v1
kind: Deployment
metadata:
  name: springboot-blue
  namespace: __NAMESPACE__
spec:
  replicas: 2
  selector:
    matchLabels:
      app: springboot-bg
      version: blue
  template:
    metadata:
      labels:
        app: springboot-bg
        version: blue
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
              value: "blue"
