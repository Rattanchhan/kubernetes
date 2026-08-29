apiVersion: v1
kind: Service
metadata:
  name: react-bluegreen-service
  namespace: __NAMESPACE__
spec:
  selector:
    app: react-bg
    version: blue
  ports:
    - port: __REACT_PORT__
      targetPort: __REACT_PORT__
