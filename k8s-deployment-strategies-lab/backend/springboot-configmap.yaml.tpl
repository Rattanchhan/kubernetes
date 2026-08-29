apiVersion: v1
kind: ConfigMap
metadata:
  name: springboot-config
  namespace: __NAMESPACE__
data:
  SPRING_PROFILES_ACTIVE: "__SPRING_PROFILES_ACTIVE__"
  DB_HOST: "postgres-service"
  DB_PORT: "__POSTGRES_PORT__"
  DB_NAME: "__POSTGRES_DB__"
  DB_USER: "__POSTGRES_USER__"
