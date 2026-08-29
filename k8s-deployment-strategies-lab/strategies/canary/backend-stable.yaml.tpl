apiVersion: apps/v1
kind: Deployment
metadata:
  name: springboot-stable
  namespace: __NAMESPACE__
spec:
  replicas: 4
  selector:
    matchLabels:
      app: springboot-canary
      track: stable
  template:
    metadata:
      labels:
        app: springboot-canary
        track: stable
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
              value: "stable"
