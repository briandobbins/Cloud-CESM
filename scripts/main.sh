#!/bin/bash

# Need to rewrite this in Python to process the JSON data, but for now, we're hacking it together as a proof-of-concept:

cd /root

if [[ "compute" == $2 ]]; then
  aws s3 cp s3://cesmapi-f72c5aee-5bc9-47ec-afb3-85431601d3f8/config.json .
  wget https://raw.githubusercontent.com/briandobbins/Cloud-CESM/master/scripts/users.py config.json > users.log
else
wget https://raw.githubusercontent.com/briandobbins/Cloud-CESM/master/scripts/os.sh
sh os.sh > os.log
  wget https://raw.githubusercontent.com/briandobbins/Cloud-CESM/master/scripts/intel.sh
  sh intel.sh > intel.log
  wget https://raw.githubusercontent.com/briandobbins/Cloud-CESM/master/scripts/opt_ncar.sh
  sh opt_ncar.sh > opt_ncar.log
  wget https://raw.githubusercontent.com/briandobbins/Cloud-CESM/master/scripts/users.py 
  aws s3 cp s3://cesmapi-f72c5aee-5bc9-47ec-afb3-85431601d3f8/config.json .
  python3 users.py config.json head > users.log
fi
