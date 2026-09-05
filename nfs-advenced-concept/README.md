# Kubernetes NFS setup

This setup uses:

- `master1`: NFS server
- `master2`, `worker1`, `worker2`: NFS clients
- NFS export: `/srv/nfs/kubernetes`

Replace `<MASTER1_IP>` everywhere below with the private IP address of
`master1` that is reachable from all Kubernetes nodes.

## 1. Install and configure the server on master1

Run these commands on `master1`:

```bash
sudo apt-get update
sudo apt-get install -y nfs-kernel-server

sudo mkdir -p /srv/nfs/kubernetes
sudo chown nobody:nogroup /srv/nfs/kubernetes
sudo chmod 0777 /srv/nfs/kubernetes

echo '/srv/nfs/kubernetes *(rw,sync,no_subtree_check,no_root_squash)' | \
  sudo tee /etc/exports.d/kubernetes.exports

sudo exportfs -rav
sudo systemctl enable --now nfs-kernel-server
sudo exportfs -v
```

For a more restrictive export, replace `*` with the cluster subnet, for
example `192.168.1.0/24`.

If UFW is enabled, allow NFS from the cluster subnet:

```bash
sudo ufw allow from <CLUSTER_SUBNET> to any port 2049 proto tcp
```

## 2. Install the client on master2, worker1, and worker2

Run these commands on each of the three client nodes:

```bash
sudo apt-get update
sudo apt-get install -y nfs-common

showmount -e <MASTER1_IP>

sudo mkdir -p /mnt/nfs-test
sudo mount -t nfs <MASTER1_IP>:/srv/nfs/kubernetes /mnt/nfs-test
echo "NFS test from $(hostname)" | sudo tee /mnt/nfs-test/$(hostname).txt
ls -la /mnt/nfs-test
sudo umount /mnt/nfs-test
```

The manual mount is only a connectivity test. Kubernetes will mount the NFS
share automatically when a pod uses the PersistentVolume.

> Install `nfs-common` on every node where an NFS-backed pod might run. If
> workloads can also be scheduled on `master1`, install `nfs-common` there as
> well.

## 3. Configure the Kubernetes manifests

Edit `nfs-storage.yml` and replace `<MASTER1_IP>` with the private IP of
`master1`:

```bash
sed -i 's/<MASTER1_IP>/192.168.1.10/g' nfs-storage.yml
```

Use your real address instead of `192.168.1.10`, then apply the resources:

```bash
kubectl apply -f nfs-storage.yml
kubectl apply -f nginx-nfs-test.yml

kubectl get pv,pvc
kubectl get pods -l app=nginx-nfs-test -o wide
```

Test shared storage through the web server:

```bash
kubectl port-forward service/nginx-nfs-test 8080:80
curl http://127.0.0.1:8080
```

Expected output:

```text
NFS shared storage is working
```

## Troubleshooting

```bash
# On master1
sudo exportfs -v
sudo systemctl status nfs-kernel-server
sudo ss -lntp | grep 2049

# On a client
showmount -e <MASTER1_IP>
sudo mount -v -t nfs <MASTER1_IP>:/srv/nfs/kubernetes /mnt/nfs-test

# In Kubernetes
kubectl describe pv nfs-pv
kubectl describe pvc nfs-pvc
kubectl describe pod -l app=nginx-nfs-test
```

Common causes of mount failures are port `2049` being blocked, an incorrect
server IP, a client missing `nfs-common`, or an export rule that does not allow
the node subnet.
