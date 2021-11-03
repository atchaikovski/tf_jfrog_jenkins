#!/bin/bash

set -ex

sudo yum install -y -q epel-release
sudo yum install -y -q s3fs-fuse

export JFROG_HOME=/opt/jfrog
sudo sh -c "echo 'JFROG_HOME=/opt/jfrog' >>/etc/profile"
export S3_BIN=/opt/s3
export S3_BUCKET=sf-project4-binaries

## here should be a var passed from Terraform to make this universal!
export JFROG_URL="jfrog.tchaikovski.link"
sudo sh -c "echo 'JFROG_URL=jfrog.tchaikovski.link' >>/etc/profile"

export ARTIFACTORY_HOME=$JFROG_HOME/artifactory
sudo sh -c "echo 'ARTIFACTORY_HOME=$JFROG_HOME/artifactory' >>/etc/profile"

sudo adduser artifactory
sudo sh -c "echo 'artifactory ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers.d/90-cloud-init-users"

# preparing to mount S3 and copy files
sudo mkdir $S3_BIN
sudo s3fs $S3_BUCKET -o use_cache=/tmp -o allow_other -o uid=1001 -o mp_umask=002 -o multireq_max=5 $S3_BIN

# check if there's anything in S3 and copy/extract/install
if [[ -f "$S3_BIN/jfrog-rpm-installer.tar.gz" ]] 
then
    echo "==> files of Artifactory found, proceed"
    sudo cp $S3_BIN/jfrog-rpm-installer.tar.gz /opt

    cd /opt
    sudo tar zxvf jfrog-rpm-installer.tar.gz
    sudo mv jfrog-platform-trial-prox-7.27.6-rpm jfrog
    echo "==> installing as a service for artifactory user"
    cd $JFROG_HOME
    sudo yum history sync
    sudo ./install.sh

    echo "==> starting Artifactory as a service"
    cd $JFROG_HOME/artifactory/var/etc/artifactory 
    sudo cp ~/artifactory.lic .
    sudo chmod 640 artifactory.lic
    sudo chown artifactory:artifactory artifactory.lic

    sudo systemctl start artifactory.service
    sudo systemctl start xray.service

    echo "==> removing jfrog archive"
    sudo rm /opt/jfrog-rpm-installer.tar.gz

    echo "==> removing secrets and unwanted stuff..."
    sudo umount $S3_BIN
    sudo umount $S3_CERTS
    sudo rm -rf $S3_BIN  
    sudo rm /etc/passwd-s3fs
    sudo rm -rf /home/centos/s3fs-*
    sudo rm $ARTIFACTORY_HOME/artifactory.rpm
    sudo rm $JFROG_HOME/xray/xray.rpm

  else

    echo "==> S3 location with JFrog binaries not found.. fix your S3 access"
    exit
fi
