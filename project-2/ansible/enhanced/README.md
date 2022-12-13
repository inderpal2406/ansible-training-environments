1. Create 5 instances - pubjump, pubans, squid-proxy, pvtjump, pvtans.
2. Copy pvt key of ansible user from pubjump to pubans to make passwordless ssh from pubans to all pubans managed hosts work for ansible user.
3. Login to pubjump with ansible user.
4. Login to pubans from pubjump with ansible user.
5. Clone ansible git repo in ansible home dir.
6. Create ansible.cfg.
7. Create inventory with IP addresses manually.
8. Create bash script to ssh to hosts using IP addresses from IP address inventory. It is required to ssh to hosts once before testing ansible ping to manually accept the host key of the hosts being sshed.
9. Create ping playbook in operation_playbooks folder.
5. Test ansible connectivity using IP addresses.
6. Create role named initial_config in roles directory.


Changes on 15 Oct, 2022:
1. Change inventory from initial_hosts to hosts in ansible.cfg, to refer to hostnames of all hosts.
2. Create 00_ssh_hosts.sh script to ssh to all hosts mentioned in hosts inventory, to accept ssh keys for first time before testing ansible ping.
3. Tested ansible ping playbook for all hosts.
4. Add ansible_user & ansible_connection keys in all file under group_vars.
5. Create host_vars dir.
6. Create bash script 01_create_host_vars_file.sh to create host_vars file for each host.
7. Created host_vars file for each host with hostname var using the bash script 01_create_host_vars_file.sh.
8. Role initial_config was already created.
9. Added task to setup hostname in initial_config role.
10. Created playbook ./do_initial_config.yml to setup hostname, timezone, motd on servers.
11. Created ./site.yml playbook and included do_initial_config.yml playbook in it.
12. Executed site.yml and hostnames got setup.
13. Got warning that include parameter would be depreciated in further ansible versions.
14. We used include to include playbooks in site.yml.
15. Instead the suggestion was to use import_playbook in place of include.
16. So, replaced include to import_playbook in site.yml.
17. Executed site.yml again and got no warnings this time.
18. Added task to setup motd in initial_config role.
19. Executed site.yml.
20. Moved do_initial_config.yml playbook to playbooks folder.
21. Modified site.yml to import playbook as playbooks/do_initial_cconfig.yml.
22. Executed site.yml and got error role initial_config not found. It now tried to search the role inside playbooks folder.
23. Because playbooks folder has the do_initial_config.yml playbook.
24. In short, the playbook which has the role mentioned in it, ansible will try to find the roles directory in same folder as the playbook.
25. So, we moved do_initial_config.yml playbook back to enhanced folder from enhanced/playbooks/ folder.
26. And updated sit.yml to import playbook do_initial_config.yml and not playbooks/do_initial_config.yml.
27. Now playbook site.yml worked as it was able to find the roles folder under enhanced folder. 
28. Our playbook do_initial_config.yml also resides in same enhanced folder.
29. We updated initial_config role to update motd. Executed same successfully.
30. We updated initial_config role to update timezone using community.general.timezone module.
31. It failed during execution with error message: couldn't resolve module/action 'community.general.timezone'
32. Our ansible version is 2.9.27 installed from standard redhat repositories.
33. It seems versions greater than 2.10 are available at the moment.
34. The ansible versions > 2.10 would be able to properly resolve collection names like community.general for module timezone.
35. Upgrading ansible version required subscription of redhat to enable required redhat repo (https://www.ansiblepilot.com/articles/how-to-install-ansible-in-rhel-8-ansible-install/).
36. Instead we just mentioned timezone in place of community.general.timezone. It worked then.
37. However, ansible 2.9.27 is able to resolve ansible.builtin collection for modules like hostname, template, etc.
38. Include role hosts_file_update in do_initial_config.yml playbook. Execution was successful.
39. Import playbook proxy.yml in site.yml.
40. Create proxy.yml playbook for squid-proxy host in enhanced folder.
41. Include role squid in proxy.yml.
42. Create role squid - ansible-galaxy role init squid (inside roles dir).
43. Faced error, during squid role execution: Syntax Error while loading YAML did not find expected.
44. Checked syntax of YAML: ansible-playbook site.yml --syntax-check
45. Checked in online YAML validator for YAML syntax.
46. Found hidden " in the line which were not visible in actual.
47. Commented the complete lineinfile module code. Wrote again this module code fresh in next lines.
48. Error was resolved.
49. Created role devops_users to create devops users and group with sudo privileges.
50. Avoided keeping pub ssh keys of devops users in files in the role and managed to supply same as a var maintained in all group vars file.
51. Updated setup_users.yml with one more play to create dev users on jump servers.
52. Created role dev_users for dev user creation.
53. Created role test_users for testers, (similar to dev_users role).
53. Used dev_users and test_users roles in setup_users.yml playbook.
54. Created proxy_env role and used it in setup_proxy_env.yml playbook.
55. Created role git.
56. Create playbook setup_git.yml which uses role git.
57. Update site.yml to import setup_git.yml playbook.
58. Needed .gitconfig file for ansible user on pubans and pvtans.
59. Tried to pass it as var in setup_git.yml - - { role: "git", users: "{{ devops_users }} + name: ansible" }
60. This didn't work as anisble gave an error that it expected a list/dict.
61. Created a var ansible_user_for_git in group_vars/all with value as a list having name as a key.
62. Then updated setup_git.yml with - { role: "git", users: "{{ devops_users }} + {{ ansible_user_for_git }}" }
63. This worked.
64. Created role editors.
65. Created setup_editors.yml playbook and included it in site.yml.
66. Create role named utilities to install common utility packages.
67. Create playbook setup_utilities.yml playbook and import it in site.yml.

Changes on 7 Dec, 2022: Migration from CG laptop to RSA workspace.
1. Created new AWS account.
2. Created IAM user in it with programmatic keys and required admin policy.
3. Downloaded those keys.
4. Installed python and aws-cli on host machine with VS code.
5. Configured aws profile in aws-cli with new keys.
6. Updated aws profile in terraform vars.
7. Got files mentioned in .gitignore file for this repo from CG laptop to workspace.
8. Executed terraform to provision resources.
9. SSH didn't work from behind the proxy. Couldn't copy pvt ssh key for ansible user to pubjump using terraform executioners.
10. Manually did so.
11. SSH also didn;t work from behind the proxy to pubjump.
12. Manually took ssh somehow.
13. Manually copied ansible pvt ssh key to pubjump and from pubjump to pubans.
14. SSH to pubjump, then to pubans.
15. CLoned this repo there.
16. Updated ansible.cfg to use initial inventory file.
17. Manually ssh to pubans from pubans to accept key for first time.
18. Executed pubans_hosts_file.yml playbook.
19. Updated ansible.cfg to use original inventory.
20. Executed bash script to ssh to all hosts from inventory for first time to accept key.
21. Executed site.yml playbook.
22. Created db-dev and web-dev servers using terraform.
21. Updated these servers in group_vars/all file in hosts file template var.
22. Changed inventory to initial inv in ansible.cfg.
22. Executed pubans_hosts_file.yml playbook.
23. Updated these hosts in actual inventory.
24. Executed bash script to ssh to all hosts again from actual inv file to accept key for new servers.
25. Updated ansible.cfg with actual inv.
26. Created vars file in host_vars dir for new servers.
27. Read through all playbooks from site.yml file within the roles to check which playbook/role needs to be executed for new servers.
28. Update required playbooks from site.yml.
29. Execute site.yml and confiure new servers as per existing playbooks.
30. Add db_server.yml in site.yml.
31. Create db_server.yml to consume mysql role.
32. create mysql role.
33. Execute site.yml after syntax check.
34. Execute mysql_secure_installation command on db-dev server (we did it using non-root) user, to secure MySQL installation.
35. Import playbook web_server.yml in site.yml.
36. Create web_server.yml to consume python_web_server role.
37. Create python_web_server role files.
38. Linux packages & python packages being installed in python_web_server role, got installed without issues for first time.
39. From second time, we started getting error as "Unable to correct problems, you have held broken packages".
40. We referred the website: https://itsfoss.com/held-broken-packages-error/
41. We modified the playbook to uninstall the packages. Executed it.
42. Then we bumped up the version of python package from 3.10 to 3.11.
43. Modifed the playbook to install the packages. Executed it.
44. Re-executed the same playbook and no errors were faced this time for broken packages.
45. Add vars for web-dev & db-dev in host_vars dir. Var added is role. This is done as we couldn't set ansible facts for these 2 systems.
46. Add configure_app.yml in site.yml.
47. Create configure_app.yml to consume the python_web_app role.
48. Create the python_web_app role.
49. We use the ansible module named mysql_db to create mysql db.
50. We specified login_host as localhost, login_user as root and login_password as root user password along with other parameters to create the DB.
51. It failed saying PyMySQL dependency is required.
52. We added task in tasks/main.yml of python_web_app role, to install PyMySQL package. This resolved the error.
53. Next error we faced was "unable to find /root/.my.cnf".
54. We specified login_host as "localhost" because the ansible module gets executed on db host and from there the connection would be for localhost.
55. When localhost is mentioned as login_host, the mysql_db module will look for the login_unix_socket file and won't consider the login_user & login_password parameters.
56. When it looks for mysql socket file, it'll search for credentials to connect in $HOME/.my.cnf file.
57. Since, we specified become as true in configure_app.yml, $HOME will become /root.
58. So, we created 2 variables in db-dev file of host_vars dir to hold values of db user & password to connect to mysql instance to create the DB.
59. We created a template file for .my.cnf file and substituted those vars in this file.
60. And the DB got created.
61. We deleted non-useful parameters from mysql_db module in the role.
62. The login_host: "localhost" parameter was also deleted as when we specify login_unix_socket parameter, the login host will be default be considered as localhost.
63. Online URL to this useful information about mysql_db ansible module: https://stackoverflow.com/questions/44614863/ansible-unable-to-find-my-cnf-cant-connect-to-local-mysql-server
64. We specified the mysql credentials in host_vars/db-dev file to connect to mysql instance in mysql_db module.
65. This is security risk, as we mentioned the credentials in plain text files.
66. This can be avoided by adopting different solutions as mentioned on: https://www.redhat.com/sysadmin/ansible-playbooks-secrets
67. We used the vars_prompt method in configure_app.yml.
68. It works and when we enter the credentials at the prompt, these are not visible on the acreen just like unix password prompt.
69. Now tasks/main.yml is updated to create DB employee_db and user db_user using mysql_db & mysql_user modules respectively.
70. SSH to db-dev and connect as root user. Create employees table and insert a value into it.

