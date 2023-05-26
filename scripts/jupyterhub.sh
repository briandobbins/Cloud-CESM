#!/bin/bash

JUPYTERHUB_ENABLED=$(jq -r ".features.jupyterhub" config.json)

if [ "$JUPYTERHUB_ENABLED" != "true" ]; then
  echo "No JupyterHub feature requested"
  return 0
fi


# OK, it's enabled, so let's set it up:

adduser -c "JupyterHub" -d /local/jupyter -s /bin/bash -u 801 -g jupyterhub jupyter


runuser -l jupyter -c 'conda create -y -n jupyterhub'
runuser -l jupyter -c 'conda install -y -n jupyterhub jupyterhub jupyterlab notebook configurable-http-proxy ipywidgets'
runuser -l jupyter -c 'conda install -y -n jupyterhub -c conda-forge sudospawner'
runuser -l jupyter -c 'npm install -g configurable-http-proxy'


cat << EOF > /etc/sudoers.d/jupyterhub
# the command(s) the Hub can run on behalf of the above users without needing a password
# the exact path may differ, depending on how sudospawner was installed

Cmnd_Alias JUPYTER_CMD = /local/jupyter/.conda/envs/jupyterhub/bin/sudospawner

# actually give the Hub user permission to run the above command on behalf
# of the above users without prompting for a password
%jupyterhub ALL=(ALL:ALL) NOPASSWD: JUPYTER_CMD


EOF

# Generate the config
runuser -l jupyter -c 'jupyterhub --generate-config'

cat << EOF >> /home/jupyter/jupyterhub_config.py
c.JupyterHub.hub_ip = '0.0.0.0'
c.JupyterHub.hub_connect_ip = '0.0.0.0'
c.Authenticator.admin_users = {'jupyter','bdobbins'}
c.JupyterHub.spawner_class = 'sudospawner.SudoSpawner'
c.Spawner.cmd = '/local/jupyter/.conda/envs/jupyterhub/bin/sudospawner'

c.JupyterHub.hub_port = 8880
c.JupyterHub.port = 443
c.ConfigurableHTTPProxy.command = ['configurable-http-proxy', '--redirect-port', '80']

#c.JupyterHub.ssl_cert = '/etc/letsencrypt/live/site/fullchain.pem'
#c.JupyterHub.ssl_key = '/etc/letsencrypt/live/site/privkey.pem'

EOF



