#!/bin/bash

JUPYTERHUB_ENABLED=$(jq -r ".features.jupyterhub" config.json)

if [ "$JUPYTERHUB_ENABLED" != "true" ]; then
  echo "No JupyterHub feature requested"
  return 0
fi


# OK, it's enabled, so let's set it up:

groupadd -g 801 jupyterhub
adduser -c "JupyterHub" -d /local/jupyter -s /bin/bash -u 801 -g jupyterhub jupyter


runuser -l jupyter -c 'conda install -y -n jupyterhub jupyterhub jupyterlab notebook configurable-http-proxy'
runuser -l jupyter -c 'conda install -y -n jupyterhub -c conda-forge sudospawner'

cat << EOF > /etc/sudoers.d/jupyterhub
____________________Begin jupytersudoers file____________________
# the command(s) the Hub can run on behalf of the above users without needing a password
# the exact path may differ, depending on how sudospawner was installed

Cmnd_Alias JUPYTER_CMD = /local/jupyter/.conda/envs/jupyterhub/bin/sudospawner

# actually give the Hub user permission to run the above command on behalf
# of the above users without prompting for a password

%jupyterhub ALL=(jupyter) /usr/bin/sudo
jupyter ALL=(%jupyterhub) NOPASSWD:JUPYTER_CMD

_____________________End jupytersudoers file____________________
EOF


