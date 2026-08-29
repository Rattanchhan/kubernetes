apiVersion: apps/v1
kind: Deployment
metadata:
  name: springboot-canary
  namespace: __NAMESPACE__
spec:
  replicas: 1
  selector:
    matchLabels:
      app: springboot-canary
      track: canary
  template:
    metadata:
      labels:
        app: springboot-canary
        track: canary
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
              value: "canary"
