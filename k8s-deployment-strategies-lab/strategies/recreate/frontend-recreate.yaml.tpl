apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-recreate
  namespace: __NAMESPACE__
spec:
  replicas: 2
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: react-recreate
  template:
    metadata:
      labels:
        app: react-recreate
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
  name: react-recreate-service
  namespace: __NAMESPACE__
spec:
  selector:
    app: react-recreate
  ports:
    - port: __REACT_PORT__
      targetPort: __REACT_PORT__
