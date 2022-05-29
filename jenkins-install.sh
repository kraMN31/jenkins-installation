#!/bin/bash

#Author: M. Nuico
#Date: 04/25/2018

##Automate Jenkins installation on CentOS7 using the official Jenkins repository.

echo -e  "\n Jenkins installation is now commencing...\n "

if

	 [ ${USER} != root ]

 then 

	 echo -e "\n You are not the root user. Please contact admin for authorization!\n "
	 exit 100 
 else
	 echo -e "\n You have root privileges. Installation will commence.\n"
fi


echo -e "\n Please wait while we install the latest version of java before we can install Jenkins...\n"
sleep 5
sudo yum install java-1.8.0-openjdk-devel -y

if
	[ $? -ne 0 ]

then
	echo -e "\n There was a problem installing java. Please contact administrator.\n "
	exit 99
fi

sleep 5
echo -e "\n Enabling the Jenkins repository... Please wait.\n "

sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo

if
	[ $? -ne 0 ]

then
	sudo yum install wget -y
	sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
fi

if
	[ $? -ne 0 ]
then
	echo -e "\nThere was an issue with the Jenkins repository. Please contact administrator.\n"
	exit 95
fi

echo -e "\n Disabling key check on the repo\n "

sudo sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/jenkins.repo

if
	[ $? -ne 0 ]

then
	echo -e "\n There was a problem disabling the keycheck on the repo. Please contact administrator.\n"
	exit 94
fi

sleep 5
echo -e "\n Installing the latest stable version of Jenkins.\n "

sudo yum install jenkins -y
if
	[ $? -ne 0 ]

then
	echo -e "\n There was a problem installing Jenkins. please contact administrator.\n "
	exit 96
fi
sleep 5
echo -e "\n Starting the Jenkins service... Please wait.\n "

sudo systemctl start jenkins
if
	[ $? -ne 0 ]

then
	echo -e "\n There was a problem starting the Jenkins service. Please contact administrator.\n"
	exit 92
fi
sleep 5

echo -e "\n Enabling the Jenkins service... Please wait.\n "
sudo systemctl enable jenkins
if
	[ $? -ne 0 ]

then
	echo -e "\n There was a problem enabling the Jenkins service. Please contact administrator.\n"
	exit 91
fi
sleep 5
echo -e "\n Opening ports for Jenkins service.\n "

sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
if
	[ $? -ne 0 ]

then
	echo -e "\n There was a problem opening ports for Jenkins service. Please contact administrator.\n"
	exit 100
fi
sleep 5
echo -e "\n Reloading ports for Jenkins service.\n "

sudo firewall-cmd --reload
if
	[ $? -ne 0 ]

then
	echo -e "\n There was a problem reloading the firewall. Please contact administrator.\n"
	exit 100
fi

echo -e "\n Please copy your password in order to log into Jenkins.\n "

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

sudo yum install net-tools -y
ifconfig | grep 192.
echo -e "\n Jenkins successfully installed! Your IP address is displayed above.\n"
