apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-rolling
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
      app: react-rolling
  template:
    metadata:
      labels:
        app: react-rolling
    spec:
      containers:
        - name: react
          image: __REACT_IMAGE__
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: __REACT_PORT__
          env:
            - name: RELEASE_VERSION
              value: "v1"
---
apiVersion: v1
kind: Service
metadata:
  name: react-rolling-service
  namespace: __NAMESPACE__
spec:
  selector:
    app: react-rolling
  ports:
    - port: __REACT_PORT__
      targetPort: __REACT_PORT__
