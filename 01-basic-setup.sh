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

## setup admin password which is like root , and useful via phpmyadmin
MYSQLPASSVPOP=`pwgen -c -1 8`
echo $MYSQLPASSVPOP > /usr/local/src/mysql-powermail-pass
mysqladmin create powermail -uroot 
echo "GRANT ALL PRIVILEGES ON powermail.* TO powermail@localhost IDENTIFIED BY '$MYSQLPASSVPOP'" | mysql -uroot 
mysqladmin -uroot reload
mysqladmin -uroot refresh

