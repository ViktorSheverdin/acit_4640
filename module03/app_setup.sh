#!/bin/sh
function mySetup(){
currentDir="$(dirname "$0")"
echo $currentDir
yum install git -y
yum install wget -y

adduser admin
echo P@ssw0rd | passwd admin --srdin
usermod -aG wheel admin
wget https://acit4640.y.vu/docs/module02/resources/acit_admin_id_rsa.pub -P ~admin/.ssh/authorized_keys

sed -r -i 's/^(%wheel\s+ALL=\(ALL\)\s+)(ALL)$/\1NOPASSWD: ALL/' /etc/sudoers
yum install epel-release vim git tcpdump curl net-tools bzip2 -y
yum update -y
#firewall-cmd --zone=public --list-all
#firewall-cmd --get-services
firewall-cmd --zone=public --add-service=http
firewall-cmd --zone=public --add-service=https
firewall-cmd --zone=public --add-service=ssh
firewall-cmd --runtime-to-permanent

setenforce 0
sed -r -i 's/SELINUX=(enforciing|disabled)/SELINUX=permissive/' /etc/selinux/config

useradd -m -r todo-app && passwd -l todo-app
yum install nodejs npm -y
yum install mongodb-server -y
systemctl enable mongod && systemctl start mongod


mkdir /home/todo-app/app
chown todo-app /home/todo-app/app
#cd /home/todo-app/app/
git clone https://github.com/timoguic/ACIT4640-todo-app.git /home/todo-app/app/
npm install --prefix /home/todo-app/app/

#TODO replace the config file
echo $currentDir
cd $currentDir
cd "$(dirname "$0")"

fileFolderPath=$(pwd)/files
echo $fileFolderPath
databasePath=${fileFolderPath}/database.js
echo $databasePath
nginxPath=${fileFolderPath}/nginx.conf
todoappPath=${fileFolderPath}/todoapp.service


cp $databasePath /home/todo-app/app/config/ -f
cat /home/todo-app/app/config/database.js

#node /home/todo-app/app/server.js
chmod -R 755 /home/todo-app
yum install nginx -y
systemctl enable nginx
systemctl start nginx

cp $nginxPath /etc/nginx/nginx.conf -f
cp $todoappPath /lib/systemd/system -f

systemctl daemon-reload
systemctl enable todoapp
systemctl start todoapp

nginx -s reload

}
mySetup

