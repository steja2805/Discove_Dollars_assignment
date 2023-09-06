steps for installing wordpress:

sudo apt update

sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql

MYSQL_ROOT_PASSWORD="S@iteja02"
echo -e "mysql-server mysql-server/root_password password your_password_here\n\
mysql-server mysql-server/root_password_again password your_password_here\n\
\nY\nyour_password_here\nyour_password_here\nY\nY\nY\nY\nY\n\n" | sudo mysql_secure_installation

sudo mysql -u root -p'S@i'

CREATE DATABASE wordpress;

CREATE USER 'teja'@'localhost' IDENTIFIED BY 'S@iteja02';
GRANT ALL PRIVILEGES ON wordpress.* TO 'teja'@'localhost';
FLUSH PRIVILEGES;
EXIT;
# u will change the usernamr(wpuser) and password

cd /var/www/html

sudo wget https://wordpress.org/latest.tar.gz

sudo tar -xzvf latest.tar.gz

sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

cd wordpress
modify the following manually

define('DB_NAME', 'wordpress');
define('DB_USER', 'teja');
define('DB_PASSWORD', 'S@iteja02');



sudo chown -R www-data:www-data /var/www/html/wordpress

sudo nano /etc/apache2/sites-available/wordpress.conf
to be written manually
<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot /var/www/html/wordpress
    ServerName your_domain.com
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

sudo a2ensite wordpress.conf

sudo systemctl restart apache2

***Mandatory remove the 000-default.comf file from its repo i.e sites-available'***

cd /etc/apache2/sites-available
sudo mv 000-default.conf ..

sudo a2ensite wordpress.conf

sudo systemctl restart apache2
***now change the wp-config.php in /var/www/html/wordpress***

________________________________________________________________________

setting up the php:

sudo apt install apache2 php libapache2-mod-php

sudo apt install -y php-gd

sudo apt install php-mysql

sudo systemctl restart apache2  # For Apache

sudo mkdir /var/www/html/aimtogoal

sudo touch info.php /var/www/html/aimtogoal

sudo a2enmod php8.1  # Use the appropriate PHP version

sudo chmod 644 /var/www/html/aimtogoal/info.php

sudo systemctl restart apache2

sudo apt update
sudo apt install -y php-fpm

sudo systemctl enable php8.1-fpm
sudo systemctl start php8.1-fpm

sudo systemctl restart apache2

sudo apt install libapache2-mod-php8.1

sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php8.1-fpm  
sudo systemctl restart apache2

sudo nano /etc/apache2/sites-available/aimtogoal.conf
make it maually
<VirtualHost *:80>
    # ... Other configuration settings ...

    DocumentRoot /var/www/html/aimtogoal
    ServerName aimtogoal.com

    <Directory /var/www/html/aimtogoal>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # Add PHP handling directives below
    <FilesMatch \.php$>
        SetHandler "proxy:unix:/var/run/php/php8.1-fpm.sock|fcgi://localhost/"
    </FilesMatch>

    # ... Other configuration settings ...
</VirtualHost>

sudo a2ensite aimtogoal.conf

sudo apache2ctl configtest

sudo systemctl restart apache2

sudo chown -R www-data:www-data /var/www/html/aimtogoal

manually
sudo vim info.php
<?php phpinfo(); ?>
---------------------------------------------------------------

after all this we wiil be creating a database in private subnet as it should not be available for the outside world.
and connect it with the container in which the wordpress is running.

To connect to the rds we use mysql -h your-rds-endpoint -u your-username -p.
now we need to connect the container having wordpress with the rds 
for that we nee to make some changes in the wp-config.php file

define('DB_NAME', 'your_database_name');
define('DB_USER', 'your_database_username');
define('DB_PASSWORD', 'your_database_password');
define('DB_HOST', 'your_rds_endpoint');

these are the values to be changed there in the config.php file.
after this the rds is perfectly connected with the container

