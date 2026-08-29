apiVersion: v1
kind: Service
metadata:
  name: react-service
  namespace: __NAMESPACE__
spec:
  selector:
    app: react-app
  ports:
    - name: http
      port: __REACT_PORT__
      targetPort: __REACT_PORT__
  type: ClusterIP
