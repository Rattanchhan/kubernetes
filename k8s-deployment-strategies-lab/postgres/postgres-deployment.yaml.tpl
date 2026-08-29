apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
  namespace: __NAMESPACE__
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: __POSTGRES_IMAGE__
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: __POSTGRES_PORT__
          envFrom:
            - secretRef:
                name: postgres-secret
          readinessProbe:
            exec:
              command:
                - /bin/sh
                - -c
                - pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"
            initialDelaySeconds: 5
            periodSeconds: 5
          volumeMounts:
            - name: postgres-data
              mountPath: /var/lib/postgresql
      volumes:
        - name: postgres-data
          persistentVolumeClaim:
            claimName: postgres-pvc
