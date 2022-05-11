#!/bin/bash

# Need to rewrite this in Python to process the JSON data, but for now, we're hacking it together as a proof-of-concept:

cd /root

#if [[ "compute" == $2 ]]; then
#  wget https://raw.githubusercontent.com/briandobbins/Cloud-CESM/master/scripts/users.py $1 $2 > users.log
#else
wget https://raw.githubusercontent.com/briandobbins/Cloud-CESM/master/scripts/os.sh
sh os.sh > os.log
#  wget https://raw.githubusercontent.com/briandobbins/Cloud-CESM/master/scripts/intel.sh
#  sh intel.sh > intel.log
#  wget https://raw.githubusercontent.com/briandobbins/Cloud-CESM/master/scripts/opt_ncar.sh
#  sh opt_ncar.sh > opt_ncar.log
#  wget https://raw.githubusercontent.com/briandobbins/Cloud-CESM/master/scripts/users.py
#  python3 users.py $1 > users.log
#fi
