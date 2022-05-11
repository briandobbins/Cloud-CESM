#!/usr/bin/env python3


import sys
import json
from passlib.hash import sha512_crypt
import pwd
import grp



def adduser(username, data, head):
    # Set up the command
    command = 'adduser '

    # Add the user:
    command += username

    # Add the real name:
    if 'name' in data:
        command += ' -c "' + data['name'] + '"'

    # Add the home directory (no changes available yet):
    command += ' -d /home/' + username

    # Add the shell (no real options yet either):
    if 'shell' in data:
        command += ' -s /bin/' + data['shell']
    else:
        command += ' -s /bin/bash'

    #account = data['account']

    # Loop over the groups, making sure they exist (and creating if not):
    for group in data['groups']:
        try:
            grp.getgrnam(group)
        except KeyError:
            print("Creating group: ", group)
            groupcommand = "groupadd " + group
            #os.system(groupcommand)

    # Now add the groups to the command:
    command += ' -g ' + data['groups'][0]
    if len(data['groups']) > 1:
        command += ' -G ' + ",".join(data['groups'][1:])

    if head:
        phash = sha512_crypt.hash(data['password'])
        command += ' -p \'' + phash  + '\''
    else:
        command += ' -M '


    #os.system(command)
    print(username, " => ", data['password'])
    #print("User Command: ", command)



# This function needs to take two arguments - 
def main():
    arguments = sys.argv

    if len(sys.argv) == 3:
        #print("Adding users from '", sys.argv[1], "' ( head = ", sys.argv[2], " ) " )

        head = False
        if sys.argv[2] == 'head':
            head = True

        with open(sys.argv[1], "r") as data:
            jsondata = json.load(data)

        data = jsondata['users']['data']
        for username in data:
            #print('user: ', username, data[username])
            adduser(username, data[username], head)



if __name__ == "__main__":
    main()



