1. Create initial required inventory, ansible.cfg, bash scripts, etc. files.
2. Add playbook 01_hosts_file_configuration.yml to update hosts file on all hosts.
3. Add playbook 02_devops_users.yml to create devops users and configure them.
4. Add playbook 03_dev_users.yml to create developer users and configure them.
5. Add playbook 04_hostname_timezone_motd_setup.yml to setup hostname, timezone & motd on hosts.
6. Add playbook 05_set_proxy_for_pkg_managers.yml to setup proxy server in pkg manager conf files.
7. Add playbook 06_apt_cache_update.yml to update apt cache in ubuntu servers when needed.
8. Add playbook 07_install_common_pkgs.yml to install common packages on all hosts.
9. Add playbook 08_configure_editors.yml to configure editor conf files in user home dir.
10. Add playbook 09_configure_proxy_for_all_users.yml to configure env vars with proxy server details for each user.
11. Add playbook 10_webserver.yml to configure web server.
12. Add playbook 11_dbserver.yml to configure db server.

