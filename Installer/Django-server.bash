#!/bin/bash

echo "Current python version:"

python --version

echo "installing virtualenv so we can give django its own version of python"

# here you can install with updates or without updates.  To install python pip with a full kernel upgrade (not somthing you would do in prod, but
# definately somthing you might do to your testing or staging server: sudo yum update

# for a prod install (no update)

# this adds the noarch release reposatory from the fedora project, wich contains python pip
# python pip is a package manager for python...

rpm -iUvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm

yum -y install python-pip

# Now we're installing virtualenv, which will allow us to create a python installation and environment, just for our Django server
pip install virtualenv

cd /opt
# we're going to install our django libs in /opt, often used for optional or add-on.  /usr/local is also a perfectly fine place for new apps
# we want to make this env accisible to the ec2-user at first, because we don't want to have to run it as root.

mkdir django
#allows permissions to the user
chown -R yojetoga django

sleep 5

cd django

virtualenv django-env

echo "activating virtualenv"

source /opt/django/django-env/bin/activate

echo "to switch out of virtualenv, type deactivate"

echo "now using:"

which python

#changing permissions to the user
chown -R yojetoga /opt/django

echo "installing django"
 
pip install django


echo "django admin is version:"

django-admin --version

django-admin startproject project1

echo "here's our new django project dir"

tree project1

echo "go to https://docs.djangoproject.com/en/1.10/intro/tutorial01/"
#obtain external IP
Ip=$(curl icanhazip.com)
#set the IP into the django setting
sed -i -e "28s/.*/ALLOWED_HOSTS = [\'$Ip\']/" /opt/django/project1/project1/settings.py
