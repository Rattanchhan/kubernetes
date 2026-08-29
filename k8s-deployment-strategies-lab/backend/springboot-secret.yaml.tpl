apiVersion: v1
kind: Secret
metadata:
  name: springboot-secret
  namespace: __NAMESPACE__
type: Opaque
stringData:
  DB_PASSWORD: "__POSTGRES_PASSWORD__"
