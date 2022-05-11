#!/bin/bash

mkdir -p /opt/ncar
cd /opt/ncar
wget https://cesm-software.s3.us-east-2.amazonaws.com/esmf.tar.gz
tar zxvf esmf.tar.gz
rm -f esmf.tar.gz

wget https://cesm-software.s3.us-east-2.amazonaws.com/software.tar.gz
tar zxvf software.tar.gz
rm -f software.tar.gz

