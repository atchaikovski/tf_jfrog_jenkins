#!/bin/bash
sudo yum install -y -q epel-release
sudo yum install -y -q s3fs-fuse

export JFROG_HOME=/opt/jfrog
sudo sh -c "echo 'JFROG_HOME=/opt/jfrog' >>/etc/profile"
export S3_BIN=/opt/s3
export S3_BUCKET=sf-project4-binaries
export JFROG_URL="jfrog.tchaikovski.link"

echo "passing var inside: "$${host_name}

sudo adduser artifactory
sudo sh -c "echo 'artifactory ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers.d/90-cloud-init-users"

# preparing to mount S3 and copy files
sudo mkdir $S3_BIN
sudo s3fs $S3_BUCKET -o use_cache=/tmp -o allow_other -o uid=1001 -o mp_umask=002 -o multireq_max=5 $S3_BIN

# check if there's anything in S3 and copy/extract/install
if [[ -f "$S3_BIN/jfrog-rpm-installer.tar.gz" ]] 
then
    echo "files of Artifactory found, proceed"
    sudo cp $S3_BIN/jfrog-rpm-installer.tar.gz /opt
    cd /opt
    sudo tar zxvf jfrog-rpm-installer.tar.gz
    sudo mv jfrog-platform-trial-prox-7.27.6-rpm jfrog
    echo "installing as a service for artifactory user"
    cd $JFROG_HOME
    sudo ./install.sh

    echo "starting as a service"
    sudo systemctl start artifactory.service
    sudo systemctl start xray.service

    echo "removing jfrog archive"
    sudo rm /opt/jfrog-rpm-installer.tar.gz

    if [[ -f "$S3_BIN/pipelines-1.19.3.tar.gz" ]]
    then
      # docker needed for pipelines
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo yum install -y -q docker-ce docker-ce-cli containerd.io
        sudo systemctl start docker
        sudo systemctl enable docker

       echo "files of pipelines found, proceed"
       sudo cp $S3_BIN/pipelines-1.19.3.tar.gz $JFROG_HOME
       cd $JFROG_HOME
       sudo tar zxvf pipelines-1.19.3.tar.gz 
       # ? check whether it's there already 
       echo "removing pipelines archive"
       sudo rm pipelines-1.19.3.tar.gz 
       sudo mv pipelines-1.19.3 pipelines

       cd pipelines
## aws_instance.artifactory_server (remote-exec): mkdir: cannot create directory ‘/opt/jfrog/pipelines/var’: Permission denied
       TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
       IPA=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/local-ipv4`
       echo "local IP is: "$IPA
       sudo ./pipelines install --base-url-ui http://$JFROG_URL:8081 \
               --artifactory-joinkey "EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE" \
               --installer-ip $IPA \
               --api-url http://$JFROG_URL:8081/artifactory/api/

    fi

        echo "removing secrets and unwanted stuff..."
        sudo umount $S3_BIN
        sudo rm -rf $S3_BIN   
        sudo rm /etc/passwd-s3fs
        sudo rm -rf /home/centos/s3fs-*

  else

    echo "S3 location with JFrog binaries not found.. fix your S3 access"

fi
