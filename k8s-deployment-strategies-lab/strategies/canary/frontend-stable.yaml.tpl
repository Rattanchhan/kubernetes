apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-stable
  namespace: __NAMESPACE__
spec:
  replicas: 4
  selector:
    matchLabels:
      app: react-canary
      track: stable
  template:
    metadata:
      labels:
        app: react-canary
        track: stable
    spec:
      containers:
        - name: react
          image: __REACT_IMAGE__
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: __REACT_PORT__
          env:
            - name: RELEASE_VERSION
              value: "stable"
