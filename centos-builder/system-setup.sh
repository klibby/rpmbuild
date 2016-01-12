#!/bin/bash -ve

### Check that we are running as root
test `whoami` == 'root';

yum_packages=()

# Dependencies for setup
yum_packages+=('wget')
yum_packages+=('curl')

yum update -y
yum install -y ${yum_packages[@]}

# Bootstrap cpanminus
curl -L https://cpanmin.us | perl - App::cpanminus

### Clean up from setup
yum clean all

# Remove the setup.sh setup, we don't really need this script anymore, deleting
# it keeps the image as clean as possible.
rm $0; echo "Deleted $0";
