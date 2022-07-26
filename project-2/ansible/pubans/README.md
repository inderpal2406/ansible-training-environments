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
71. Create playbook 09_configure_editors.yml to configure editor settings for users.
72. 2 lists can be concatenated as "{{ list1 }} + {{ list2 }}"
73. hosts: "pubans" "pvtcontroller" won't work but hosts: "pvtans pubcontroller" would work. Defining multiple host targets.
74. Create playbook 10_configure_proxy_for_all_users.yml to configure proxy env vars for all users on all hosts.
75. Placing a bash script in /etc/profile.d dir of each host to setup proxy vars in user env, would help setup proxy var in sessions authenticated with key/password & ssh sessions from remote host executed to run commands from remote host.
76. Create playbook 11_configure_pvtans.yml to configure pvtans server completely.
77. Playbook from 00 to 09 were read and tasks applicable for pvtans server from those playbooks were written in 11 playbook.
78. pvtans server was not included in tasks of previous playbooks. We wanted to have separate playbook just to configure pvtans fully.
79. Since, pvtans is in private subnet, it had proxy server configured in yum conf file to connect to pkg repos on internet via proxy server.
80. While cloning remote git repo of ansible-training-environments to pvtans under each devops user's and ansible user's home dir, we got an error that remote git repo is not reachable.
81. This was because in playbook, ansible has escalated privilege to root user and was trying to clone the repo as root user.
82. This couldn't happen as proxy server details were not set at user level.
83. So, playbook 10_configure_proxy_for_all_users.yml was written to setup env vars having proxy server details in each user's env.
84. So, no each user's (including root) user had env vars with proxy server details.
85. However, when any user tried to execute a command using sudo, then env used to get changed and proxy vars used to disappear. Maybe sudo initiates its env in a different way.
86. So, we created a file in /etc/sudoers.d dir to instruct sudo to keep env vars HTTP_PROXY HTTPS_PROXY from user env in sudo env as well.
87. This was done in playbook 10. While creating playbook 10, we committed below mistakes,<br>
Actual possible line in file: Defaults env_keep += "ftp_proxy http_proxy https_proxy no_proxy"
First mistake: i didn't add "", instead complete line as "Defaults env_keep += ftp_proxy http_proxy https_proxy no_proxy" in copy task content # so sudoers was corrupted
Second mistake: 'Defaults env_keep += "ftp_proxy http_proxy https_proxy no_proxy"\n' in content in copy module - \n get copied as it is and corrupted sudoers.
Third mistake: 'Defaults env_keep += "ftp_proxy http_proxy https_proxy no_proxy"' in content in copy module - worked properly in ubuntu but not on redhat as redhat needed new line char at the end.
Recreated redhat ans servers - then manually add same line with no \n and checked if it corrupts the file. Without neline char at end of line in sudoers, redhat doesn't read it properly.
So, fourth mistake: Defaults env_keep += "ftp_proxy http_proxy https_proxy no_proxy"\n in content of copy task - \n gets copied as well to the file and corrupts sudoers file.
Finally we tried with block in blockinfile module and it worked. Block content doesn't need to be quoted and if quoted, the quotes get copied as it is.
88. blockinfile module needs an argument "create" set to yes to create a file with content of block if the file doesn't exist.
89. File module can be used to change ownership of an existing directory by using dest, state: "directory", owner, group, recurse arguments.
90. Create pvtjump server.
91. Update it in all required files and playbooks and configure it using ansible.
92. Add playbook 07a_update_apt_cache_on_ubuntu.yml to update apt cache before pkg installation on ubuntu hosts. At times pkg installation on ubuntu hosts fail as apt cache is not updated, particularly in new hosts.
93. If we specify regexp in lineinfile module along with insertafter, the line gets inserted after required line, but the line having regexp is deleted. Since we wanted to keep the line with regexp, we didn't use regexp argument in lineinfile module in playbook 12_increase_ssh_session_timeout.yml.
94. Playbook 12_increase_ssh_session_timeout.yml is written to increase timeout duration for ssh session. But still the ssh session to EC2 instance gets reset after inactivity. So, this didn't prove usefule.
95. Add private subnet host entries in hosts files in pubans dir. Ultimately pvt subnet hosts entries are needed on pvtans. Pvtans is managed by pubans. So, we update hosts file in pubans which in turn will update on pub subnet hosts as well.

