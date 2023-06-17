#!/bin/bash
# This script install Adobe Commerce 2.4.5 with composer


# 
echo " Run this script www-data user or magneto_user with file system permission"
echo " This script is tested on Ubuntu 22.04 LTS"

############### Don't use this in production #################
# Disable Two Factor Authentication
php bin/magento module:disable Magento_TwoFactorAuth



# Intall cron job
# bin/magento cron:install --force # use --force to rewrite existing cron job

# Install sample data
bin/magento setup:perf:generate-fixtures /var/www/my-magento-project/setup/performance-toolkit/profiles/ce/small.xml

# If you get error like this: "SQLSTATE[HY000]: General error:" run in MySQL with root user
    set global log_bin_trust_function_creators=1;

