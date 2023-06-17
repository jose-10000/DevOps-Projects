#!/bin/bash
# Deployment of Adobe Commerce 2.4.5 on Ubuntu 22.04 LTS

# Update the system
sudo apt update -y # || sudo apt upgrade -y

# Install Apache2
sudo apt install apache2 -y

############################# Install PHP 8.1 #############################

# Install PHP
sudo apt install php8.1 -y


# Install PHP Extensions
sudo apt install php8.1-{bcmath,bz2,curl,intl,gd,mbstring,mysql,zip,soap,xml} -y
sudo systemctl restart apache2

# In order to improve the performance of PHP, we will make some changes in the php.ini file.
sudo sed -i "s/memory_limit = .*/memory_limit = 1G/" /etc/php/8.1/apache2/php.ini # 1G recommended for production, 2G for development and ~3-4G for testing
#sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 256M/" /etc/php/8.1/apache2/php.ini
#sudo sed -i "s/max_execution_time = .*/max_execution_time = 360/" /etc/php/8.1/apache2/php.ini
#sudo sed -i "s/post_max_size = .*/post_max_size = 256M/" /etc/php/8.1/apache2/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = Europe\/Rome/" /etc/php/8.1/apache2/php.ini
sudo sed -i "s/;realpath_cache_size = .*/realpath_cache_size = 10M/" /etc/php/8.1/apache2/php.ini
sudo sed -i "s/;realpath_cache_ttl = .*/realpath_cache_ttl = 7200/" /etc/php/8.1/apache2/php.ini

# The following line will enable opcache in PHP 8.1 and will improve the performance of PHP
sudo tee -a /etc/php/8.1/apache2/php.ini <<EOF
zend_extension=opcache.so
opcache.enable=1
opcache.enable_cli=1
opcache.jit_buffer_size=500000000
opcache.jit=1235
EOF


sudo tee -a /etc/php/8.1/apache2/conf.d/opcache.ini <<EOF
[opcache]
opcache.enable=1
; 0 means it will check on every request
; 0 is irrelevant if opcache.validate_timestamps=0 which is desirable in production
opcache.revalidate_freq=0
opcache.validate_timestamps=1
opcache.max_accelerated_files=10000
opcache.memory_consumption=192
opcache.max_wasted_percentage=10
opcache.interned_strings_buffer=16
opcache.fast_shutdown=1
EOF

# Restart Apache2
sudo systemctl restart apache2


# Set up apache virtual host
sudo tee -a /etc/apache2/sites-available/my-magento-project.conf <<EOF
<VirtualHost *:80>
    ServerName magentoc.lcl
    DocumentRoot /var/www/my-magento-project/pub
    <Directory /var/www/my-magento-project>
        AllowOverride All
        Options Indexes FollowSymLinks Multiviews
        Require all granted
    </Directory>
</VirtualHost>
EOF

# Restart Apache2
sudo a2ensite /etc/apache2/sites-available/my-magento-project.conf
sudo a2enmod rewrite
sudo systemctl restart apache2



################# Don't use this in production #################
# Make phpinfo.php file to check PHP version and extensions installed
#U ncomment this line to create phpinfo.php file if you want to check PHP version and extensions installed
#sudo echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php


######################################################################

# Install MySQL
sudo apt install mysql-server -y
sudo systemctl start mysql.service
sudo systemctl enable mysql.service
# sudo mysql_secure_installation



# Install Composer
sudo apt install composer -y

# Install Java
sudo apt install openjdk-11-jdk -y

# Install Git
sudo apt install git -y
# sudo apt install maven -y




######################################################################


# Install Elastic Search
sudo apt install apt-transport-https -y
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg
echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update -y
sudo apt install elasticsearch -y
# Configure Elastic Search
sudo sed -i "s/#cluster.name: my-application/cluster.name: magento/" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s/#node.name: node-1/node.name: magento/" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s/#network.host: 192.168.0.1 /network.host: localhost/" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s/#http.port: 9200/http.port: 9200/" /etc/elasticsearch/elasticsearch.yml

sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

# Check Elastic Search status
# curl -X GET "localhost:9200/"


# Now go to Magento server and install Magento 2.4.5

echo "The script to continue the installation is in the Magento server /temp/adobe_install.sh" 







