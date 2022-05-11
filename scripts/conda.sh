#!/bin/bash

wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.11.0-Linux-x86_64.sh
bash -b -p /opt/ncar/conda

# Add to path:
echo 'export PATH=/opt/ncar/conda/bin:${PATH}' > /etc/profile.d/conda.sh

/opt/ncar/conda/bin/conda install passlib
