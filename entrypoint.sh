#!/bin/sh
# cp config files
cp -R /opt/rc/.bashrc /opt/rc/.inputrc /opt/rc/.configrc /opt/rc/.fzf.bash /opt/rc/.fzf /root/
# passwd for jupyter
SHA1=$(python /opt/config/passwd.py $PASSWD)
echo "c.NotebookApp.password = '$SHA1'">>/opt/config/jupyter_lab_config.py
# passwd for rserver
echo rserver:$PASSWD | chpasswd
# passwd for root
echo root:$PASSWD | chpasswd
# passwd for code-server
echo "command=/opt/code-server/code-server -P '$PASSWD' -d /root/.config/.vscode -e /root/.config/.vscode-extentions">>/opt/config/supervisord.conf
# change port for ssh
sed -i 's/Port 22/Port 8822/g' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
# start server with supervisor
/usr/bin/supervisord -c /opt/config/supervisord.conf
