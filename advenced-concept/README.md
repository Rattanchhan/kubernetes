## NOTE FOR TAINTs, TOLERATION, AFFINITY, NATI-AFFINITY

'''
kubectl get node -A
kubectl describe node <node_name> # search taints

# Untaint master node
kubectl taint nodes <master_node_name> node-role.kubernetes.io/control-plane-

# Taint master node
kubectl taint nodes <master_node_name> node-role.kubernetes.io/control-plane=:NoSchedule

# Taint worker node
kubectl taint nodes <worker_node_name> service=disabled:NoSchedule

# Untaint worker node
kubectl taint ndoes <worker_node_name> service-
'''

## AFFINITY RELATED
# Label two machine that has disk-type=ssd
kubectl label nodes <node_name> disktype=ssd
kubectl label nodes <node_name> disktype=ssd
kubectl label nodes <node_name> disktype=hdd
