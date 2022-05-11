#!/bin/bash

# Install various tools we need for users (some of these are probably already on here, but I'm aiming for
# consistency with the container setup, so duplicates will just be skipped)
yum -y upgrade
yum -y install vim emacs-nox git subversion which sudo csh make m4 cmake wget file byacc curl-devel zlib-devel
yum -y install perl-XML-LibXML gcc-gfortran gcc-c++ dnf-plugins-core perl-core ftp numactl-devel

# Set up the 'python' alias to point to Python3 -- this is going away for newer CESM releases, I think?
#ln -s /usr/bin/python3 /usr/bin/python




