# Deploy Spring Boot on master-1 with shared NFS logs

Run from `instance1`:

```bash
cd /home/ubuntu/kubernetes/nfs-advenced-concept
ansible-playbook -i ansible/inventory.ini ansible/prepare-spring-logs.yml
kubectl taint node master-1 workload=springboot:NoSchedule --overwrite
kubectl apply -f springboot-nfs-master1.yml
kubectl rollout status deployment/springboot-nfs -n bank-app
kubectl get pod -n bank-app -l app=springboot-nfs -o wide
kubectl get pv springboot-logs-nfs-pv
kubectl get pvc springboot-logs -n bank-app
```

The pod must show `master-1` in the `NODE` column.

View the log on `master1`:

```bash
sudo tail -f /srv/nfs/kubernetes/springboot-logs/springboot-nfs.log
```

View the same log on `master2`, `worker1`, or `worker2`:

```bash
sudo tail -f /mnt/nfs/kubernetes/springboot-logs/springboot-nfs.log
```

Remove the dedicated taint later with:

```bash
kubectl taint node master-1 workload=springboot:NoSchedule-
```
