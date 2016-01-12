#!/bin/bash -ve

### Check that we are running as root
test `whoami` == 'root';

yum_packages=()

# Dependencies for setup
yum_packages+=('which')
yum_packages+=('wget')
yum_packages+=('curl')
yum_packages+=('tar')
yum_packages+=('gcc')
yum_packages+=('perl-core')
yum_packages+=('rpm-build')
yum_packages+=('ruby-devel')
yum_packages+=('rubygems')

yum update -y
yum install -y ${yum_packages[@]}

# Bootstrap cpanminus
curl -L https://git.io/cpanm | perl - App::cpanminus

# Same for cpan2rpm
mkdir -p $HOME/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
cpanm http://search.cpan.org/CPAN/authors/id/B/BB/BBB/cpan2rpm-2.028_02.tar.gz

# Same for fpm
gem install fpm

### Clean up from setup
yum clean all

# Remove the setup.sh setup, we don't really need this script anymore, deleting
# it keeps the image as clean as possible.
rm $0; echo "Deleted $0";
