1. Create initial inventory with IP addresses as hosts file on all hosts is not updated.
2. Create a file with ip addresses from initial inventory using bash script.
3. SSH to all hosts using ip addresses from the above file to accept key for first time.
4. Then run ansible ping playbook for all IPs.
5. Playbook to copy hosts file to ubuntu & redhat hosts in public subnet & pvtans server.
6. Take copy of initial inventory as inventory file.
7. Run bash script to replace ips to hostnames in inventory.
8. Create a file with hostnames from inventory using bash script.
9. SSH to all hosts using hostnames from the above file to accept key one more time.
10. Playbook to ensure git is latest & .gitconfig is configured for ansible user on pubans.
11. Commit changes to git repo as ansible user and push changes.
