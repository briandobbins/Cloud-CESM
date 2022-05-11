#!/bin/bash

mkdir -p /opt/ncar
cd /opt/ncar
aws s3 cp --recursive s3://cesm-software/software ./software
aws s3 cp --recursive s3://cesm-software/esmf ./esmf

