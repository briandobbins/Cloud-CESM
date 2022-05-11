#!/bin/bash

# Overwrite the 'efa.sh' profile setting to only add EFA, not AWS's OpenMPI
cat << EOF > /etc/profile.d/efa.sh
PATH="/opt/amazon/efa/bin/:$PATH"
EOF

# Set up the CESM profile:
cat << EOF > /etc/profile.d/cesm.sh
#export PATH=/opt/ncar/cesm/cime/scripts:${PATH}
export CIME_MACHINE=aws-hpc6a
export LD_LIBRARY_PATH=/opt/ncar/software/lib:${LD_LIBRARY_PATH}


export OMP_NUM_THREADS=1
export I_MPI_OFI_LIBRARY_INTERNAL=0
export I_MPI_FABRICS=ofi
export I_MPI_OFI_PROVIDER=efa

export PATH=/opt/ncar/software/bin:${PATH}
export PATH=/opt/ncar/conda/bin:${PATH}

export LD_LIBRARY_PATH=/opt/amazon/efa/lib64:${LD_LIBRARY_PATH}

export ESMFMKFILE=/opt/ncar/esmf/lib/esmf.mk
EOF


