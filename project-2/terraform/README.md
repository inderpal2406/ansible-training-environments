1. Public IP was decided to be allocated to only pubjump & squid-proxy hosts.
2. But pubans is also given public IP, so that ansible can be installed on it in user_data.
3. This ansible installation is using public internet directly & not via the proxy server.
4. Because, it was decided to install squid proxy using ansible afterwards.
5. An approach of bare minimum configuration during provisioning is followed and rest of the configuration would be done using ansible.
6. Only ansible pre-requisites, like python3, ansible user, public key of ansible user from ansible server copied to authorized_keys file on all hosts, are being done during provisioning.
7. On pubjump, private key file of ansible user from pubans is copied, so that initial login to pubans from pubjump can be done.
8. Once users on all hosts are setup using ansible, we won't use ansible user. We'll use individual users to login.
9. Also plan is to manually copy private ssh key of ansible user on pubans from pubjump server. Otherwise, we need to open pubans for public ssh.
10. This private key is already provisioned to pubjump to login to pubans for initial use using ansible user.
11. Also plan is to install ansible on pvtans using pubans. This is the only host in private subnet which would be managed by pubans.
