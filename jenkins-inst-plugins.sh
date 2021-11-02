#!/bin/bash
set -ex

#Install Basic plugins
sudo yum -y -q install unzip
sudo curl -o batch-install-jenkins-plugins.sh https://gist.githubusercontent.com/micw/e80d739c6099078ce0f3/raw/33a21226b9938382c1a6aa68bc71105a774b374b/install_jenkins_plugin.sh
sudo chmod +x batch-install-jenkins-plugins.sh
git config --global http.sslVerify false
sudo systemctl stop jenkins
sudo mkdir -p /var/lib/jenkins/plugins
#sudo ./batch-install-jenkins-plugins.sh -p plugins -d /var/lib/jenkins/plugins
sudo ./batch-install-jenkins-plugins.sh $(echo $(cat plugins.txt))
sudo systemctl start jenkins 
sleep 60