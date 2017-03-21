#!/bin/bash

Napostgres=pos3
Napostgres=production
#install postgresql
yum -y install epel-release-7
yum -y install postgresql-server postgresql-contrib

echo "Installing git..."
yum -y install git

#initiate postgresql
postgresql-setup initdb

#install and start HTTP
yum -y install httpd
systemctl enable httpd
systemctl start httpd

#set the firewall rule for postgres
firewall-cmd --permanent --zone=public --add-service=postgresql
firewall-cmd --reload

#enable and start the postgresql server
systemctl start postgresql
systemctl enable postgresql

#postgres account to setup database
sudo sh -c 'cat > /var/lib/pgsql/postgres.sql' << EF
ALTER USER postgres WITH PASSWORD '123456';
CREATE DATABASE project1;
CREATE USER project1 WITH PASSWORD '123456';
ALTER ROLE project1 SET client_encoding TO 'utf8';
ALTER ROLE project1 SET default_transaction_isolation TO 'read committed';
ALTER ROLE project1 SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE project1 TO project1;
EF

sudo -i -u postgres psql -U postgres -f /var/lib/pgsql/postgres.sql

#modifying the postgresql.conf file to listen any Ip
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/pgsql/data/postgresql.conf

#modifying pg.hba.conf file
sed -i "s/ident/md5/g" /var/lib/pgsql/data/pg_hba.conf
sed -i -e "\$ahost    all             all             0.0.0.0/0      md5" /var/lib/pgsql/data/pg_hba.conf

#restart postgress to set up the changes
sudo -i -u postgres pg_ctl reload

#Installing phpPgAdmin
yum -y install phpPgAdmin

#modifying phpPgAdmin configuration to allows the access to the webside
sed -i 's,  Require local,  Require all granted,g' /etc/httpd/conf.d/phpPgAdmin.conf

#modifiying config.inc.php
sed -i "14s/.*/\t\$conf['servers'][0]['desc'] = '$Napostgres PostgreSQL';/" /etc/phpPgAdmin/config.inc.php
sed -i "18s/.*/\t\$conf['servers'][0]['host'] = 'localhost';/" /etc/phpPgAdmin/config.inc.php
sed -i "31s/.*/\t\$conf['servers'][0]['defaultdb'] = 'postgres';/" /etc/phpPgAdmin/config.inc.php
sed -i "93s/.*/\t\$conf['extra_login_security'] = false;/" /etc/phpPgAdmin/config.inc.php
sed -i "99s/.*/\t\$conf['owned_only'] = true;/" /etc/phpPgAdmin/config.inc.php

#allow db to connect on httpd
sudo setsebool -P httpd_can_network_connect_db on

#restart postgres and httpd services
systemctl restart postgresql
systemctl restart httpd
