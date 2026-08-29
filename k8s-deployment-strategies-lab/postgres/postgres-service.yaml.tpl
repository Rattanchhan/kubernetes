apiVersion: v1
kind: Service
metadata:
  name: postgres-service
  namespace: __NAMESPACE__
spec:
  selector:
    app: postgres
  ports:
    - name: postgres
      port: __POSTGRES_PORT__
      targetPort: __POSTGRES_PORT__
  type: ClusterIP
