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
50. Created git_repos dir in home dir of all devops users on pubans using 03_users.yml.
51. Tried to create block of tasks such as templating .gitconfig & creating git_repos dir together and loop through same list of devops users. But got error as block may not support loop. Need to read more on this.
52. Declared devops users as list of vars in the play and looped tasks through it by using item in arguments & template file.
53. Git module in ansible can be used to clone the remote git repo.
54. However, it'll clone the repo into the dir specified and won't create a new dir with same name as repo as in normal git clone.
55. File module, state argument if set to absent for a dir, will delete the dir recursively even if it is not empty. No special argument like force exists to delete a non-empty dir.
56. Create var file for each host in host_vars dir of pubans.
57. Create 04_hostname_timezone_setup.yml playbook to setup hostnames of all hosts.
58. Ansible facts in a task/handler can be mentioned as ansible_facts["fact_name"].
59. These cannot be mentioned as vars using jinja2 format, like "{{ ansible_distribution }}". It gave error to us in this format.
60. Task to update timezone added in playbook 04_hostname_timezone_setup.yml.
61. In current setup, this task notifies multiple handlers using listen parameter in the handlers to restart cron service.
62. The handler will run based on ansible fact value for that host otherwise gets skipped.
63. Add playbook 05_configure_squid_proxy.yml to install squid & allow all traffic through it.
64. Add playbook 06_set_proxy_on_hosts.yml to configure proxy details for yum & apt to connect to public pkg repos on public internet via proxy server.
65. Need to check how proxy details for each user can be setup so that they connect to public internet via proxy server.
66. If a task fails for a specific host, then next task won't run for that host. But next task will execute for other hosts.
67. Running package for ubuntu hosts at times won't be able to install the package though the package exists in ubuntu repos.
68. In such cases, we manually login to ubuntu host, run "sudo apt-get update" to update the repo details. Then run the playbook and most probably it'll get installed this time.
69. Add playbook 07_common_pkgs.yml to install common packages on all hosts. Exception is bat which is installed only on ubuntu hosts as it is not available in yum repos of redhat.
70. Create playbook 08_dev_test_users.yml to create & configure dev & tester user accounts on pubjump server for now.

