#!/bin/bash
#This file is used to set up folder permissions for Magento


echo " Run this script as root or sudo user"
echo " This script is tested on Ubuntu 22.04 LTS"



# Setting up Apache2 folder permissions for Magento
# A file sysem user owner is required to install Magento
sudo adduser magento_user
sudo usermod -a -G www-data magento_user # add magento_user to www-data group
sudo chown -R magento_user:www-data /var/www
sudo chmod g+rwx /var/www # give write permission to group