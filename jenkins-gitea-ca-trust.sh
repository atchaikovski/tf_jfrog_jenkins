#!/bin/bash
set -ex

# Create the CA cert file from the variable, move into proper folder, update permissions and trust
echo -n '@@{Gitea.GITEA_CA}@@' | base64 --decode >> gitca.crt
sudo mv gitca.crt /etc/pki/ca-trust/source/anchors/.
sudo chown root:root /etc/pki/ca-trust/source/anchors/gitca.crt
sudo chmod 644 /etc/pki/ca-trust/source/anchors/gitca.crt
sudo update-ca-trust