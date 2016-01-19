#!/bin/bash

echo "Memulai provisioning"

echo "Setup Software Sources"
cp /vagrant/provisioning/config/sources.list /etc/apt/sources.list
cp /vagrant/provisioning/config/environment /etc/environment

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

echo "Instalasi Git"

apt-get install -y git


echo "Install Nginx dari PPA"
add-apt-repository -y ppa:nginx/stable
apt-get update
apt-get install -y nginx

echo "Konfigurasi Virtual Host Nginx"
mkdir /home/vagrant/aplikasisaya
cp /vagrant/provisioning/config/coba.php /home/vagrant/aplikasisaya/
cp /vagrant/provisioning/config/nginx-vhost /etc/nginx/sites-available/aplikasisaya
ln -s /etc/nginx/sites-available/aplikasisaya /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
service nginx restart

echo "Instal HHVM dari PPA"
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
add-apt-repository "deb http://dl.hhvm.com/ubuntu $(lsb_release -sc) main"
apt-get update
apt-get install -y hhvm
/usr/share/hhvm/install_fastcgi.sh
/usr/bin/update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60

echo "Setup MySQL"
apt-get install -y debconf-utils

debconf-set-selections <<< "mysql-server mysql-server/root_password password admin"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password admin"

apt-get install -y mysql-server

echo "Install Composer"
curl -sS https://getcomposer.org/installer | php
mv /home/vagrant/composer.phar /usr/local/bin/composer

echo "Install Codeception"
curl -LsS http://codeception.com/codecept.phar -o /usr/local/bin/codecept
chmod a+x /usr/local/bin/codecept

echo "Install Laravel"
rm -rf aplikasi
composer create-project laravel/laravel aplikasi

echo "Selesai provisioning"
