apiVersion: apps/v1
kind: Deployment
metadata:
  name: springboot-app
  namespace: __NAMESPACE__
spec:
  replicas: 4
  selector:
    matchLabels:
      app: springboot-app
  template:
    metadata:
      labels:
        app: springboot-app
    spec:
      tolerations:
        - key: "node-role.kubernetes.io/control-plane"
          operator: "Exists"
          effect: "NoScheduler"
      nodeSelector:
        kubenetes.io/hostname: worker1
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                  - key: disktype
                    operator: in
                    values:
                      - ssd
        podAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - podAffinityTerm:
                labelSelector:
                  matchExpressions:
                    - key: app
                      operator: In
                      values:
                        - springboot-app
                topologyKey: kubernetes.io/hostname
              weight: 100

        podnAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - podAffinityTerm:
                labelSelector:
                  matchExpressions:
                    - key: app
                      operator: In
                      values:
                        - springboot-app
                topologyKey: kubernetes.io/hostname
              weight: 100
      containers:
        - name: springboot
          image: __SPRINGBOOT_IMAGE__
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: __SPRINGBOOT_PORT__
          envFrom:
            - configMapRef:
                name: springboot-config
            - secretRef:
                name: springboot-secret
          env:
            - name: RELEASE_VERSION
              value: "base"
          volumeMounts:
            - name: springboot-app-valumeMounts
              mountPath: app/src/main/resorces/images
      volumes:
        - name: spring-images-volumeMounts
          hostPath:
            path: /var/images
        - name: config-volumeMounts
          configMap:
            name: index-configMap
            items:
              - key: index.html
                path: /html/index.html