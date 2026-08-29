apiVersion: v1
kind: Service
metadata:
  name: springboot-canary-service
  namespace: __NAMESPACE__
spec:
  selector:
    app: springboot-canary
  ports:
    - port: __SPRINGBOOT_PORT__
      targetPort: __SPRINGBOOT_PORT__
