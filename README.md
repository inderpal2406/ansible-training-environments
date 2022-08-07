# ansible-training-environment
Repository to hold IaC files to create and configure infrastructure required to practise ansible concepts.

### Manual things that were done to setup this environment.
- Copy id pvt key from bastion to ansible server, so that ansible server can ssh to target hosts using same key. This key is the keypair using which ansible and all target hosts have got created. This needs to be done everytime when the ansible server gets recreated.
- Copy pvt key from bastion to ansible server. This pvt key if of bastion server key-pair, which is used to ssh to bastion server. This is to enable ansible-server to ssh to bastion server.
- First ssh to all target hosts from ansible server with manual prompt of yes to accept the key. this needs to be done again if ever the key of target host changes. It is observerd, that key of the EC2 instance changes when it changes state from stopped to running. This host key checking can be disbaled by setting the "host_key_checking" parameter as False in ansible.cfg file. But host key checking should not be disabled in production environments to prevent Man in the Middle attacks.
- Manually clone the ansible-training-environment git repo to ansible server to put in the playbooks. Before cloning the proxy details need to be updated in git config.
- Public subnet VMs don't have proxy settings for apt and can reach out to internet directly.