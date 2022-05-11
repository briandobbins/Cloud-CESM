#!/bin/bash

# Need to rewrite this in Python to process the JSON data, but for now, we're hacking it together as a proof-of-concept:

cd /root


if [[ "compute" == $2 ]]; then
  aws s3 cp $1/config.json .
  wget https://raw.githubusercontent.com/briandobbins/Cloud-CESM/master/scripts/users.py .
  /opt/ncar/conda/bin/python3 users.py config.json > users.log
else
  mkdir -p /opt/ncar/config
  chmod go-rwx /opt/ncar/config
  wget https://raw.githubusercontent.com/briandobbins/Cloud-CESM/master/scripts/os.sh
  sh os.sh > /opt/ncar/config/os.log
  wget https://raw.githubusercontent.com/briandobbins/Cloud-CESM/master/scripts/conda.sh
  sh conda.sh > /opt/ncar/config/conda.log
  wget https://raw.githubusercontent.com/briandobbins/Cloud-CESM/master/scripts/intel.sh
  sh intel.sh > /opt/ncar/config/intel.log
  wget https://raw.githubusercontent.com/briandobbins/Cloud-CESM/master/scripts/opt_ncar.sh
  sh opt_ncar.sh > /opt/ncar/config/opt_ncar.log
  wget https://raw.githubusercontent.com/briandobbins/Cloud-CESM/master/scripts/users.py 
  aws s3 cp $1/config.json .
  /opt/ncar/conda/bin/python3 users.py config.json head > users.log
fi
