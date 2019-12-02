#!/bin/sh



##http://www.microhowto.info/howto/make_the_configuration_of_iptables_persistent_on_debian.html
## save the rules
#iptables-save > /etc/iptables/rules.v4
#ip6tables-save > /etc/iptables/rules.v6
## restore rules
#iptables-restore < /etc/iptables/rules.v4
#ip6tables-restore < /etc/iptables/rules.v6

echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections

apt-get -y install iptables-persistent


## take one backup for safety
sh files/rootdir/bin/etc-config-backup.sh


a2enmod actions > /dev/null 2>&1 
a2enmod proxy_fcgi > /dev/null 2>&1 
a2enmod alias > /dev/null 2>&1 
a2enmod suexec > /dev/null 2>&1
a2enmod rewrite > /dev/null 2>&1
a2enmod ssl > /dev/null 2>&1
a2enmod actions > /dev/null 2>&1
a2enmod include > /dev/null 2>&1
a2enmod dav_fs > /dev/null 2>&1
a2enmod dav > /dev/null 2>&1
a2enmod auth_digest > /dev/null 2>&1
#a2enmod fcgid > /dev/null 2>&1
a2enmod cgi > /dev/null 2>&1
a2enmod headers > /dev/null 2>&1
a2enmod proxy_http > /dev/null 2>&1
#a2enmod fastcgi > /dev/null 2>&1
a2ensite default-ssl > /dev/null 2>&1	
a2ensite proxy_http > /dev/null 2>&1	

## setup admin password which is like root , and useful via phpmyadmin


MYSQLPASSVPOP=`pwgen -c -1 8`
echo $MYSQLPASSVPOP > /usr/local/src/mysql-admin-pass
echo "mysql admin password in /usr/local/src/mysql-admin-pass"

echo "GRANT ALL PRIVILEGES ON *.* TO admin@localhost IDENTIFIED BY '$MYSQLPASSVPOP'" with grant option | mysql -uroot
mysqladmin -uroot reload
mysqladmin -uroot refresh


echo "NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org" >> /etc/systemd/timesyncd.conf
timedatectl set-timezone 'Asia/Kolkata'
timedatectl set-ntp true
timedatectl status


### changing timezone to Asia Kolkata
sed -i "s/;date.timezone =/date\.timezone \= \'Asia\/Kolkata\'/" /etc/php/7.3/apache2/php.ini
sed -i "s/;date.timezone =/date\.timezone \= \'Asia\/Kolkata\'/" /etc/php/7.3/cli/php.ini
systemctl restart  systemd-timedated systemd-timesyncd

## restart rsyslog show that mail.log shows proper time
/etc/init.d/rsyslog restart
/etc/init.d/apache2 restart

# make cpan auto yes for pre-requist modules.
(echo y;echo o conf prerequisites_policy follow;echo o conf commit)|cpan

## remove apache default page with simple name
echo  "Web-Apps server"> /var/www/html/index.html 
