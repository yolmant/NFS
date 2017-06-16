#!/bin/bash

whiptail --title "IG Server Installer" --msgbox "Welcome to the IG Server installer\n you will be able to create instances with specific features servers and clients" 10 60

status=0

while [ $status = 0 ]
do

	Menu=$(whiptail --title "IG Server Installer" --menu "Choose one of the next options" 15 60 5 \
	"1" "Firewall permissions" \
	"2" "Create the whole network with 8 servers and 1 client" \
	"3" "Create individual instance" \
	"4" "Delete Instances" 3>&1 1>&2 2>&3)
	
	status=$?

	if [ $status = 0 ]; then

		if [ $Menu = 1 ]; then
			{
				#gcloud compute firewall-rules create allow-http --description "allowing http." --allow tcp:80

				#gcloud compute firewall-rules create allow-https --description "allowing https." --allow tcp:443

				#gcloud compute firewall-rules create allow-ldap --description "allowing LDAP." --allow tcp:636
				
				sleep 1m	
			} | whiptail --title "IG Server Installer" --msgbox "Firewalls already included" 10 60

		elif [ $Menu = 2 ]; then
			{
				for ((i = 0 ; i <= 100 ; i+=10)); do
					if [ $i = 10 ]; then
						#gcloud compute instances create ldap-server --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/ldap-s.bash
						sleep 10s	
					elif [ $i = 20 ]; then		
						#gcloud compute instances create nfs-server --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/nfs-s.bash
						sleep 10s
					elif [ $i = 30 ]; then
						pos1=test

						#sed -i "4s/.*/Napostgres=$pos1/" /home/yojetoga/Servers/Gcloud/postgres.bash

						#gcloud compute instances create postgres-test --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/postgres.bash

						sleep 1m

					elif [ $i = 40 ]; then
						#Ippos=$(gcloud compute instances list | grep postgres-test | awk '{print $4}')

						#sed -i "3s/.*/Ippost=$Ippos/" /home/yojetoga/Servers/Gcloud/django.bash

						#gcloud compute instances create django-test --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/django.bash
						sleep 10s
					elif [ $i = 50 ]; then
						#pos2=staging

						#sed -i "4s/.*/Napostgres=$pos2/" /home/yojetoga/Servers/Gcloud/postgres.bash

						#gcloud compute instances create postgres-staging --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/postgres.bash

						sleep 1m
					
					elif [ $i = 60 ]; then
						#Ippos=$(gcloud compute instances list | grep postgres-staging | awk '{print $4}')

						#sed -i "3s/.*/Ippost=$Ippos/" /home/yojetoga/Servers/Gcloud/django.bash

						#gcloud compute instances create django-staging --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/django.bash
						sleep 10s
					elif [ $i = 70 ]; then
						#pos3=production

						#sed -i "4s/.*/Napostgres=$pos3/" /home/yojetoga/Servers/Gcloud/postgres.bash

						#gcloud compute instances create postgres-production --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/postgres.bash

						sleep 1m

					elif [ $i = 80 ]; then
						#Ippos=$(gcloud compute instances list | grep postgres-production | awk '{print $4}')
						#sed -i "3s/.*/Ippost=$Ippos/" /home/yojetoga/Servers/Gcloud/django.bash

						#gcloud compute instances create django-production --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/django.bash
						sleep 10s
					elif [ $i = 90 ]; then
						#Ipl=$(gcloud compute instances list | grep ldap-server | awk '{print $4}')

						#Ipnfs=$(gcloud compute instances list | grep nfs-server | awk '{print $4}')

						#sed -i -e "17s,.*,sed -i \"30s\,uri ldapi:///\,uri ldaps://$Ipl/\,g\" \/etc\/ldap.conf,g" /home/yojetoga/Servers/Gcloud/client.bash

						#sed -i "45s/.*/Ipserver=$Ipnfs/" /home/yojetoga/Servers/Gcloud/client.bash

						#gcloud compute instances create client --image-family ubuntu-1604-lts --image-project ubuntu-os-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/client.bash
						sleep 10s
					elif [ $i = 100 ]; then
						sleep 1m
					fi	
					echo $i
				done 
			
			} | whiptail --gauge "Please wait while creating the network" 6 60 0

			whiptail --title "Network automated" --msgbox "All instances and servers installed" 10 60
						
		elif [ $Menu == 3 ]; then
			Select=$(whiptail --title "Check list Servers-Clients" --checklist \
				"Choose user's permissions" 20 78 4 \
				"Client" "Create a client instance" ON \
				"LDAP" "Create a LDAP server" OFF \
				"Postgres" "Create a Postgres server" OFF \
				"Django" "Create a Django server" OFF \
				"NFS" "Create a NFS server" OFF 3>&1 1>&2 2>&3)

			exitstatus=$?
			if [ $exitstatus == 0 ]; then
    				if echo $Select | grep Client
				then
					instance=$(whiptail --title "Instances creator" --inputbox "Name of the instance:" 10 60 3>&1 1>&2 2>&3)
 
					exitstatus=$?
					if [ $exitstatus = 0 ]; then
						IP=$(whiptail --title "Instances creator" --inputbox "IP of the LDAP server" 10 60 0.0.0.0 3>&1 1>&2 2>&3)
						exitstatus=$?
                                        	if [ $exitstatus = 0 ]; then
							IPNFS=$(whiptail --title "Instances creator" --inputbox "IP of the NFS server" 10 60 0.0.0.0 3>&1 1>&2 2>&3)
							exitstatus=$?
                                        		if [ $exitstatus = 0 ]; then
								sed -i -e "17s,.*,sed -i \"30s\,uri ldapi:///\,uri ldaps://$IP/\,g\" \/etc\/ldap.conf,g" /home/yojetoga/Servers/Gcloud/client.bash

                                				sed -i "45s/.*/Ipserver=$IPNFS/" /home/yojetoga/Servers/Gcloud/client.bash

                                				gcloud compute instances create $instance --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/client.bash	
							fi
						fi
					fi
				fi
				
				if echo $Select | grep LDAP
				then
					instance=$(whiptail --title "Instances creator" --inputbox "Name of the instance:" 10 60 3>&1 1>&2 2>&3)

                                        exitstatus=$?
                                        if [ $exitstatus = 0 ]; then
						gcloud compute instances create $instance --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/ldap-s.bash
					
					fi
				fi
				
				if echo $Select | grep Postgres
				then
					instance=$(whiptail --title "Instances creator" --inputbox "Name of the instance:" 10 60 3>&1 1>&2 2>&3)

                                        exitstatus=$?
                                        if [ $exitstatus = 0 ]; then
						sed -i "4s/.*/Napostgres=$instance/" /home/yojetoga/Servers/Gcloud/postgres.bash

                                		gcloud compute instances create $instance --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/postgres.bash
					fi
				fi
			
				if echo $Select | grep Django
				then
					instance=$(whiptail --title "Instances creator" --inputbox "Name of the instance:" 10 60 3>&1 1>&2 2>&3)

                                        exitstatus=$?
                                        if [ $exitstatus = 0 ]; then
						IP=$(whiptail --title "Instances creator" --inputbox "IP of the Postgres server" 10 60 0.0.0.0 3>&1 1>&2 2>&3)
                                                        exitstatus=$?
                                                        if [ $exitstatus = 0 ]; then
								sed -i "3s/.*/Ippost=$IP/" /home/yojetoga/Servers/Gcloud/django.bash
								gcloud compute instances create $instace --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/django.bash
						
							fi
					fi
				fi

				if echo $Select | grep NFS
				then
					instance=$(whiptail --title "Instances creator" --inputbox "Name of the instance:" 10 60 3>&1 1>&2 2>&3)

                                        exitstatus=$?
                                        if [ $exitstatus = 0 ]; then
						gcloud compute instances create $instance --image-family centos-7 --image-project centos-cloud --machine-type f1-micro --metadata-from-file startup-script=/home/yojetoga/Servers/Gcloud/nfs-s.bash
						
					fi
				fi
			fi
		
		elif [ $Menu = 4 ]; then
			instance=$(whiptail --title "Instances Terminator" --inputbox "Name of the instance you would like to delete:" 10 60 3>&1 1>&2 2>&3)
			exitstatus=$?
                        if [ $exitstatus = 0 ]; then
				{
					Ip=$(gcloud compute instances list | grep $instance | awk '{print $4}')
					gcloud compute instances delete $instance -q
					gcloud compute ssh yojetoga@nagios-server --command "bash /home/yojetoga/Nagios/Installers/remover.sh $instance $Ip"
				} | whiptail --title "Instances Terminator" --msgbox "Instances $instance has been deleted" 10 60
			fi					
		fi
	fi
done
