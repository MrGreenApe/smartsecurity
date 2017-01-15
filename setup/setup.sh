parallel-ssh -i -A -H "ub1 ub2" -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" echo hi
parallel-ssh -i -A -H "ub1 ub2 ub3" -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo apt-get install -y nfs-client
parallel-ssh -i -A -H "ub0 ub1 ub2 ub3" -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo mkdir /mirror
parallel-ssh -i -A -H "ub0 ub1 ub2 ub3" -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo mkdir /mirror
parallel-ssh -i -A -H "ub1 ub2 ub3" -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo mount ub0:/mirror /mirror
parallel-ssh -i -A -H "ub0 ub1 ub2 ub3" -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo newusers /mirror/userfile
parallel-ssh -i -A -h /mirror/hosts -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo apt-get install -y mpich2