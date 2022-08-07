## What playbooks do?
- Ensures git is latest & configured with proper .gitconfig parameters on all hosts in private subnet.
- Ensures jq is latest on all hosts in private subnet.
- Ensures batcat is latest & symlink created for bat, on all ubuntu machines in private & public subnet.
- Ensure timezone is IST & cron service restarted on timezone change in all hosts.
- Ensure motd is setup on all AWS hosts.
