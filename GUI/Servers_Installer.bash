#!/bin/bash

whiptail --title "IG Server Installer" --msgbox "Welcome to the IG Server installer\n you will be able to create instances with specific features servers and clients" 10 60

lp=0

while [ $lp = 0 ]
do

	Menu=$(whiptail --title "IG Server Installer" --menu "Choose one of the next options" 15 60 5 \
	"1" "Firewall permissions" \
	"2" "Create the whole network with 8 servers and 1 client" \
	"3" "Create individual server" \
	"4" "Create client" 3>&1 1>&2 2>&3)
	
	status=$?

	if [ $status = 0 ]; then

		if [ $Menu = 1 ]; then
			{
				gcloud compute firewall-rules create allow-http --description "allowing http." --allow tcp:80

				gcloud compute firewall-rules create allow-https --description "allowing https." --allow tcp:443

				gcloud compute firewall-rules create allow-ldap --description "allowing LDAP." --allow tcp:636
			
			} | whiptail --title "IG Server Installer" --msgbox "Firewalls already included" 10 60

		elif [ $Menu = 2 ]; then
			{
				gcloud compute instances create ldap-server --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/ldap-s.bash

				gcloud compute instances create nfs-server --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/nfs-s.bash

				pos1=test

				sed -i "4s/.*/Napostgres=$pos1/" /home/yojetoga/Servers/Gcloud/postgres.bash

				gcloud compute instances create postgres-test --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/postgres.bash

				sleep 1m

				Ippos=$(gcloud compute instances list | grep postgres-test | awk '{print $4}')

				sed -i "3s/.*/Ippost=$Ippos/" /home/yojetoga/Servers/Gcloud/django.bash

				gcloud compute instances create django-test --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/django.bash

				pos2=staging

				sed -i "4s/.*/Napostgres=$pos2/" /home/yojetoga/Servers/Gcloud/postgres.bash

				gcloud compute instances create postgres-staging --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/postgres.bash

				sleep 1m

				Ippos=$(gcloud compute instances list | grep postgres-staging | awk '{print $4}')

				sed -i "3s/.*/Ippost=$Ippos/" /home/yojetoga/Servers/Gcloud/django.bash

				gcloud compute instances create django-staging --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/django.bash

				pos3=production

				sed -i "4s/.*/Napostgres=$pos3/" /home/yojetoga/Servers/Gcloud/postgres.bash

				gcloud compute instances create postgres-production --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/postgres.bash

				sleep 1m

				Ippos=$(gcloud compute instances list | grep postgres-production | awk '{print $4}')

				sed -i "3s/.*/Ippost=$Ippos/" /home/yojetoga/Servers/Gcloud/django.bash

				gcloud compute instances create django-production --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/django.bash

				Ipl=$(gcloud compute instances list | grep ldap-server | awk '{print $4}')

				Ipnfs=$(gcloud compute instances list | grep nfs-server | awk '{print $4}')

				sed -i -e "17s,.*,sed -i \"30s\,uri ldapi:///\,uri ldaps://$Ipl/\,g\" \/etc\/ldap.conf,g" /home/yojetoga/Servers/Gcloud/client.bash

				sed -i "45s/.*/Ipserver=$Ipnfs/" /home/yojetoga/Servers/Gcloud/client.bash

				gcloud compute instances create client --image-family ubuntu-1604-lts --image-project ubuntu-os-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/client.bash

