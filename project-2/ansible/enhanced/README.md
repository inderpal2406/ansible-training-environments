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

