apiVersion: v1
kind: Service
metadata:
  name: springboot-service
  namespace: __NAMESPACE__
spec:
  selector:
    app: springboot-app
  ports:
    - name: http
      port: __SPRINGBOOT_PORT__
      targetPort: __SPRINGBOOT_PORT__
  type: ClusterIP
