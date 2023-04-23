#!bin/bash

service vsftpd start

sed -i 's/#write_enable/write_enable/' /etc/vsftpd.conf
sed -i 's/#chroot_local_user/chroot_local_user/' /etc/vsftpd.conf
echo 'user_sub_token=$USER' >> /etc/vsftpd.conf
echo 'local_root=/home/$USER/ftp' >> /etc/vsftpd.conf
echo 'pasv_enable=YES' >> /etc/vsftpd.conf
echo 'pasv_min_port=10000' >> /etc/vsftpd.conf
echo 'pasv_max_port=10100' >> /etc/vsftpd.conf
echo 'userlist_file=/etc/vsftpd.userlist' >> /etc/vsftpd.conf
echo 'userlist_deny=NO' >> /etc/vsftpd.conf

adduser $ftp_user --disabled-password

echo "$ftp_user:$ftp_pwd" | chpasswd

mkdir /home/$ftp_user/ftp

chown nobody:nogroup /home/$ftp_user/ftp

chmod a-w /home/$ftp_user/ftp

mkdir /home/$ftp_user/ftp/upload

chown $ftp_user:$ftp_user /home/$ftp_user/ftp/upload

echo $ftp_user | tee -a /etc/vsftpd.userlist

service vsftpd stop

/usr/sbin/vsftpd