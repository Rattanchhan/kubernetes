apiVersion: v1
kind: Service
metadata:
  name: react-canary-service
  namespace: __NAMESPACE__
spec:
  selector:
    app: react-canary
  ports:
    - port: __REACT_PORT__
      targetPort: __REACT_PORT__
