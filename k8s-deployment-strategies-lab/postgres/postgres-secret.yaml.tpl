apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
  namespace: __NAMESPACE__
type: Opaque
stringData:
  POSTGRES_USER: "__POSTGRES_USER__"
  POSTGRES_PASSWORD: "__POSTGRES_PASSWORD__"
  POSTGRES_DB: "__POSTGRES_DB__"
