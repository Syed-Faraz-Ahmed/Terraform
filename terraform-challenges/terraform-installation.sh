#!/bin/bash
version=$1
sudo apt-get install unzip -y
wget https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_amd64.zip
unzip terraform_${version}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
