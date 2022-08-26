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
12. Work to create devops team members users on all hosts targetted from pubans.
13. DevOps team members can login to pubans then and update playbooks by themselves and not use common ansible user.
14. SSH keys for each devops team member created in terraform folder's ssh-keys folder.
15. Public keys for each user added in pubans files to be copied to authorized_keys file of each user on each server.
16. 03_users.yml created to create devops group on all hosts targetted from pubans.
17. devops group would have sudo privilege with NOPASSWD from /etc/sudoers.d/devops_group file.
18. We setup users without passwords and copy ssh key to authorized_keys file.
19. These users had properties like password never expires, account never expires, etc by default.
20. These users would authenticate with their pvt ssh key to pubjump.
21. Then copy their pvt ssh key to pubjump and from their we can ssh to all hosts using pvt key.
22. This is as how we do it in RSA.
23. NOPASSWD sudo privilege would ensure users don't have to put in password while running sudo command.
23. %devops ALL=(ALL) NOPASSWD:ALL
24. This is because password is not setup during user creation.
25. This could be a risk. So we tried to setup password as well for users.
26. to create hashed passwords on pubans, we installed expect package for redhat using playbook.
27. However, the mkpasswd binary from this package didn't had the --method argument to specify algorithm to hash the password.
28. Command: mkpasswd --method=sha-512 or mkpasswd --method=sha512
28. So, we used openssl command to create hashed password.
29. openssl passwd -6	# -6 for sha512
30. openssl was available by default on redhat pubjump host.
31. When we setup password for user, even then the user had no expiry of password & account by default on pubjump.
32. We decided to enable password expiry after 90 days to ensure more security.
33. Also we updated sudo privilege for devops group to require password.
34. %devops ALL=(ALL:ALL) ALL
35. But it would become difficult for users to remember their passwords as well especially if these expire on hosts at different times.
36. So we dropped idea of passwords for users. Only key based authentication while login and sudo priivilege without password.
36. We removed all devops users again by changing state to absent. But didn;t use force argument in user module for this.
36. Because of this, the home dir was not deleted for the users though the users were deleted.
36. When users were created again, authorized_keys task didn;t change on the hosts anything as the home dir already existed.
37. we removed expect package from pubans host.
38. created bash scripts to remove chached keys in known_hosts file and ssh to hosts to cache keys again, to mitigate issues of ansible connectivity when hosts are destroyed & created again.
39. Now we'll commit changes and push to remote repo using ansible user.
40. Then use inderpal user to update playbooks going forward.
41. Logged in to pubans as inderpal user and created host_vars & group_vars dirs.
42. ansible_user: ansible was set in group_vars/all file.
43. ansible_connection: local was set in host_vars/pubans.
44. Tried to run 00_ping.yml. It worked only for pubans as connection was local.
45. It failed for all other hosts saying ssh key permission denied.
46. It may tried to login to remote hosts using inderpal account which had pub key on all hosts but not pvt key on pubans.
47. But with our logic it should have used ansible user keys. Need to read more on this.
48. Switched to ansible user on pubans and started further playbook development.
49. Add play in 03_users.yml to create .gitconfig file for all devops team users on pubans using template module.

