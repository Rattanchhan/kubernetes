apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-green
  namespace: __NAMESPACE__
spec:
  replicas: 2
  selector:
    matchLabels:
      app: react-bg
      version: green
  template:
    metadata:
      labels:
        app: react-bg
        version: green
    spec:
      containers:
        - name: react
          image: __REACT_IMAGE__
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: __REACT_PORT__
          env:
            - name: RELEASE_VERSION
              value: "green"
