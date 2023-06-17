#!/bin/bash
# This script install Adobe Commerce 2.4.5 with composer


# 
echo " Run this script www-data user or magneto_user with file system permission"
echo " This script is tested on Ubuntu 22.04 LTS"


# Download Magento, for this you need to have Magento account, and generate access keys
# https://marketplace.magento.com/
cd /var/www


composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=2.4.5 my-magento-project2


# Set file permissions
cd /var/www/my-magento-project
find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
chown -R :www-data . # Ubuntu
chmod u+x bin/magento

# Remember set up MySQL database





# Install Magento
cd /var/www/my-magento-project2
bin/magento setup:install \
--base-url=http://magentoc.lcl \
--db-host=localhost \
--db-name=magento3 \
--db-user=magento3 \
--db-password=#Magento3 \
--admin-firstname=admin \
--admin-lastname=admin \
--admin-email=admin@admin.com \
--admin-user=admin \
--admin-password=admin123 \
--language=en_US \
--currency=USD \
--timezone=Europe/Rome \
--use-rewrites=1 \
--search-engine=elasticsearch7 \
--elasticsearch-host=localhost \
--elasticsearch-port=9200 \
--elasticsearch-index-prefix=magento2 \
--elasticsearch-timeout=15 \
--backend-frontname=admin

