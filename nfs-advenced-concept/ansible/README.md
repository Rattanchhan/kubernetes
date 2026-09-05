# Run the NFS automation from instance1

Prerequisites:

- Ansible is installed on `instance1`.
- `instance1` can SSH to all four nodes.
- The remote SSH user has passwordless `sudo`.
- TCP port `2049` is allowed between the Kubernetes nodes.

Edit `inventory.ini` and replace the four private-IP placeholders. Update
`ansible_user` and `ansible_ssh_private_key_file` if your values differ.

For a non-lab environment, replace `nfs_allowed_network: "*"` in
`group_vars/all.yml` with the private subnet, such as `172.31.0.0/16`.

Run:

```bash
cd /home/ubuntu/kubernetes/nfs-advenced-concept/ansible

ansible all -m ping
ansible all -b -m command -a 'whoami'
ansible-playbook site.yml --syntax-check
ansible-playbook site.yml --check --diff
ansible-playbook site.yml
```

The playbook:

- installs and configures `nfs-kernel-server` on `master1`;
- exports `/srv/nfs/kubernetes`;
- installs `nfs-common` on `master2`, `worker1`, and `worker2`;
- persists and mounts the share at `/mnt/nfs/kubernetes` on every client;
- checks port `2049` and verifies read/write access from every client.

To run only one part:

```bash
ansible-playbook site.yml --limit nfs_server
ansible-playbook site.yml --limit nfs_clients
```
