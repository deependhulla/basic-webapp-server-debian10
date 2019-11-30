#!/bin/sh

## remove old phpmyadmin if any -- forced way 
rm -rf /var/www/html/phpmyadmin 1>/de/null 2>/dev/ull

PHPMYADMINVERSION=4.9.2
wget -c https://files.phpmyadmin.net/phpMyAdmin/4.9.2/phpMyAdmin-$PHPMYADMINVERSION-english.tar.gz -O /tmp/phpMyAdmin-$PHPMYADMINVERSION-english.tar.gz

cd /var/www/html/
tar -xzf /tmp/phpMyAdmin-$PHPMYADMINVERSION-english.tar.gz

mv /var/www/html/phpMyAdmin-$PHPMYADMINVERSION-english /var/www/html/phpmyadmin

/bin/cp -p /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php
chown -R www-data:www-data /var/www/html/phpmyadmin
