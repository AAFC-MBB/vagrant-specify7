#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y xorg gnome-core gnome-system-tools gnome-app-install
sudo apt-get install --no-install-recommends ubuntu-desktop

if [ ! -d /usr/lib/jvm/java-8-oracle ]; then
add-apt-repository -y ppa:webupd8team/java 
apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
apt-get install -y oracle-java8-installer
fi

#apt-add-repository -y ppa:ptn107/apache
#apt-get update
apt-get install -y apache2 libapache2-mod-wsgi
a2enmod wsgi
service apache2 stop

if [ ! -e ./Specify_unix_64.sh ]; then
wget http://update.specifysoftware.org/Specify_unix_64.sh
sh ./Specify_unix_64.sh </vagrant/s6_responses.txt
fi
apt-get install -y git python-pip python-dev libmysqlclient-dev build-essential nodejs-legacy
git clone https://github.com/specify/specify7.git
pip install -r specify7/requirements.txt



ln -sf /vagrant/specify_settings.py specify7/specifyweb/settings/local_specify_settings.py
ln -sf /vagrant/specifyweb_apache.conf specify7/local_specifyweb_apache.conf
ln -sf /vagrant/specify_settings.py specify7/specifyweb/settings/specify_settings.py
ln -sf /vagrant/specifyweb_apache.conf specify7/specifyweb_apache.conf
make -C specify7/specifyweb clean
make -C specify7/specifyweb



rm /etc/apache2/sites-enabled/*
ln -sf /vagrant/local_specifyweb_apache.conf /etc/apache2/sites-enabled/
chown -R www-data:www-data /home/vagrant/specify7

service apache2 start
