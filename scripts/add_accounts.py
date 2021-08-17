#!/usr/bin/env python3

import csv
import pwd
import grp
import secrets
import string
import os
import crypt
import sys
import pandas as pd

def AssignFromSeries(name, default_value, series):
    if name in series:
        return series[name]
    else:
        return default_value



def AccountExists(name):
    try:
        pwd.getpwnam(name)
    except KeyError:
        return False

    return True



def GroupExists(name):
    try:
        grp.getgrnam(name)
    except KeyError:
        return False

    return True


def GeneratePassword():
    # Our first preference is to use word-based passwords, if /usr/share/dict/words exists:
    if os.path.exists('/usr/share/dict/words'):
        with open('/usr/share/dict/words') as wordlist:
            words = [word.strip() for word in wordlist]
            password = ' '.join(secrets.choice(words) for i in range(4))
            return password

    # Otherwise, use random characters:
    alphabet = string.ascii_letters + string.digits
    password = ''.join(secrets.choice(alphabet) for i in range(10))
    return password



    



def AddUser(userdata):
    valid = False

    # Convert the column names to a list:
    userinfo = userdata.index.tolist()

    # Assign variables, using defaults if not present:
    account = AssignFromSeries('Account', '',         userdata)
    group   = AssignFromSeries('Group',   'users',    userdata)
    name    = AssignFromSeries('Name',    '',         userdata)
    shell   = AssignFromSeries('Shell',   'bash',     userdata)
    method  = AssignFromSeries('Method',  'Password', userdata)
    data    = AssignFromSeries('Data',    '',         userdata)

    # If account is valid (we have an account name, and it doesn't already exist), add it:
    if account and not AccountExists(account):
        # First, if the group doesn't exist, add it:
        if not GroupExists(group):
            command = "groupadd " + group
            os.system(command)

        # Check if the shell is either 'bash' or 'tcsh', or '/bin/bash', or '/bin/tcsh'
        # If it's the first two, set it to the full form:
        if shell in ['bash', 'tcsh']:
            shell = "/bin/" + shell
        if shell not in ['/bin/bash', '/bin/tcsh']:
            return

        # Next, check that we have a valid method - otherwise we default to password:
        if method not in ['Password', 'PublicKey']:
            method = 'Password'

        # If we're using a password, check if we have a supplied one in data, otherwise generate one:
        if method == 'Password':
            if not data:
                data = GeneratePassword()

        # Set up some simple aliases:
        homedir  = "/home/"+account

        # Create the command, bit by bit:
        command = "adduser " + account + " "
        command += "-c '" + name + "' "
        command += "-d " + homedir + " "
        command += "-g " + group + " "
        command += "-s " + shell + " "

        # If we have a Password, add the password line, otherwise, add a command to insert the key:
        if method == 'Password':
            command += "-p " + crypt.crypt(data) + " "
        else:
            sshdir = "/home/" + account + "/.ssh"
            command += "; mkdir " + sshdir
            command += "; echo '" + data + "' >> " + sshdir + "/authorized_keys"
            command += "; chmod 0700 " + sshdir
            command += "; chmod 0600 " + sshdir + "/authorized_keys"
            command += "; chown -R " + account + ":" + group + " " + sshdir
            os.system(command)


def main():
    # We're always going to have a default user list for now, so create a list of all arguments:
    arguments = sys.argv

    # And overwrite the name of this program with the defaults:
    arguments[0] = 'https://github.com/NCAR/Cloud-CESM/defaults/users.csv'

    for arg in arguments:
        try:
            df = pd.read_csv(arg)

            for index in range(df.shape[0]):
                AddUser(df.iloc[index])

        except:
            print("Can't read file: ", arg)



if __name__ == "__main__":
    main()

