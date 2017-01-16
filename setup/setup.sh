sudo nano /etc/hosts
sudo apt-get update
sudo apt-get install ssh
sudo apt-get install pssh
parallel-ssh -i -A -H "ub1 ub2 ub3 ub4 ub5 ub6 ub7 ub8 ub9" -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" echo hi
parallel-ssh -i -A -H "ub1 ub2 ub3 ub4 ub5 ub6 ub7 ub8 ub9" -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo apt-get install -y nfs-client
parallel-ssh -i -A -H "ub0 ub1 ub2 ub3 ub4 ub5 ub6 ub7 ub8 ub9" -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo mkdir /mirror
sudo apt-get install nfs-server
echo "/mirror *(rw,sync)" | sudo tee -a /etc/exports
sudo service nfs-kernel-server restart
parallel-ssh -i -A -H "ub1 ub2 ub3 ub4 ub5 ub6 ub7 ub8 ub9" -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo mount ub0:/mirror /mirror
sudo cp /etc/hosts /mirror
parallel-ssh -i -A -H "ub1 ub2 ub3 ub4 ub5 ub6 ub7 ub8 ub9" -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo ls /mirror

cd /mirror
sudo chmod 777 /mirror/
nano userfile
#mpiu:<password removed>:1002:1000:MPI user:/mirror:/bin/bash
cat userfile
parallel-ssh -i -A -H "ub0 ub1 ub2 ub3 ub4 ub5 ub6 ub7 ub8 ub9" -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo newusers /mirror/userfile
sudo chown mpiu /mirror
sudo apt-get install ssh
su mpiu
ssh-keygen -t rsa
cd .ssh
cat id_rsa.pub >> authorized_keys
ssh ub1 hostname
parallel-ssh -i -A -H "ub0 ub1 ub2 ub3 ub4 ub5 ub6 ub7 ub8 ub9" -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo chmod 777 /mirror/*

parallel-ssh -i -A -H "ub0 ub1 ub2 ub3 ub4 ub5 ub6 ub7 ub8 ub9" -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo apt-get install -y mpich
parallel-ssh -i -A -H "ub0 ub1 ub2 ub3 ub4 ub5 ub6 ub7 ub8 ub9" -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo apt-get install -y libssl-dev

#Others
parallel-ssh -i -A -H "ub0 ub1 ub2 ub3 ub4 ub5 ub6 ub7 ub8 ub9" -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo shutdown -r now
parallel-ssh -i -A -H "ub0 ub1 ub2 ub3 ub4 ub5 ub6 ub7 ub8 ub9" -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo userdel mpiu
ssh-keygen –t rsa

sudo apt-get install openmpi-bin openmpi-common openssh-client openssh-server libopenmpi-dev
sudo apt-get install -y libssl-dev
parallel-ssh -i -A -H "ub1 ub2" -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" echo hi
parallel-ssh -i -A -H "ub1 ub2 ub3" -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo apt-get install -y nfs-client
parallel-ssh -i -A -H "ub0 ub1 ub2 ub3" -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo mkdir /mirror
echo "/mirror *(rw,sync)" | sudo tee -a /etc/exports
parallel-ssh -i -A -H "ub1 ub2 ub3" -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo mount ub0:/mirror /mirror
parallel-ssh -i -A -H "ub0 ub1 ub2 ub3" -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo newusers /mirror/userfile
parallel-ssh -i -A -h /mirror/hosts -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo apt-get install -y mpich
parallel-ssh -i -A -h /mirror/hosts -l usr -x "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null" sudo apt-get install -y libssl-dev
