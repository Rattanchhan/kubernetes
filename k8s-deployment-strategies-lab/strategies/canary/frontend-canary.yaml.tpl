apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-canary
  namespace: __NAMESPACE__
spec:
  replicas: 1
  selector:
    matchLabels:
      app: react-canary
      track: canary
  template:
    metadata:
      labels:
        app: react-canary
        track: canary
    spec:
      containers:
        - name: react
          image: __REACT_IMAGE__
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: __REACT_PORT__
          env:
            - name: RELEASE_VERSION
              value: "canary"
