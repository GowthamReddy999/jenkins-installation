#!/bin/bash

validate() {

if [ $1 -ne 0 ]; then
        echo "$2 is failure"
        exit 1
else
        echo "$2 is success"
fi
}
USERID=$(id -u)

if [ $USERID -ne 0 ]; then
        echo "you to need to shift into root user to excute script "
        exit 1
fi
apt update -y
validate $? "system package update"
apt install fontconfig openjdk-21-jre curl gnupg -y
validate $? "java runtime environment"
java -version
validate $? "java version"
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg
validate $? "jenkins key download"
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/" \
> /etc/apt/sources.list.d/jenkins.list
validate $? "jenkins repository"
apt update -y
validate $? "update packages"
apt install jenkins -y
validate $? "jenkins installation"
systemctl start jenkins
validate $? "jenkins start"
systemctl enable jenkins
validate $? "jenkins enable"
systemctl status jenkins
validate $? "jenkins status"

