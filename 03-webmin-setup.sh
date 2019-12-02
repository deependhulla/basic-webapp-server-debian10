## install webmin
echo "deb http://download.webmin.com/download/repository sarge contrib " > /etc/apt/sources.list.d/webmin.list
curl -s http://www.webmin.com/jcameron-key.asc | apt-key add -
apt-get update
apt-get -y install webmin
## change port from 10000 to 8383
sed -i "s/10000/8383/g" /etc/webmin/miniserv.conf
/etc/init.d/webmin restart

