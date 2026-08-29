apiVersion: v1
kind: Service
metadata:
  name: springboot-bluegreen-service
  namespace: __NAMESPACE__
spec:
  selector:
    app: springboot-bg
    version: blue
  ports:
    - port: __SPRINGBOOT_PORT__
      targetPort: __SPRINGBOOT_PORT__
