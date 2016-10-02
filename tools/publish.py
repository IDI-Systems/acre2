#!/usr/bin/env python3

# Author: PabstMirror

# Uploads ace relases to workshop
# Will slice up compats to their own folders

import sys

if sys.version_info[0] == 2:
    print("Python 3 is required.")
    sys.exit(1)

import os
import os.path
import shutil
import platform
import glob
import subprocess
import hashlib
import configparser
import json
import traceback
import time
import timeit
import re
import fnmatch
import argparse
import psutil
import pysftp

if sys.platform == "win32":
    import winreg

def get_project_version(version_file):
    majorText = ""
    minorText = ""
    patchText = ""
    buildText = ""
    try:
        if os.path.isfile(version_file):
            f = open(version_file, "r")
            hpptext = f.read()
            f.close()

            if hpptext:
                majorText = re.search(r"#define MAJOR (.*\b)", hpptext).group(1)
                minorText = re.search(r"#define MINOR (.*\b)", hpptext).group(1)
                patchText = re.search(r"#define PATCHLVL (.*\b)", hpptext).group(1)
                buildText = re.search(r"#define BUILD (.*\b)", hpptext).group(1)

        else:
            print_error("A Critical file seems to be missing or inaccessible: {}".format(version_file))
            raise FileNotFoundError("File Not Found: {}".format(version_file))

    except Exception as e:
        raise Exception("Check the integrity of the file: {}".format(version_file))

    return [majorText, minorText, patchText, buildText]

def find_steam_exe():
    reg = winreg.ConnectRegistry(None, winreg.HKEY_CURRENT_USER)
    try:
        k = winreg.OpenKey(reg, r"Software\Valve\Steam")
        steam_path = winreg.QueryValueEx(k, "SteamExe")[0]
        winreg.CloseKey(k)
        return steam_path.replace("/", "\\")
    except:
        raise Exception("BadSteam","Steam path could not be located! Please make sure that Steam is properly installed.")

def start_steam_with_user(username, password):
    PROCNAME = "Steam.exe"
    steam_path = find_steam_exe()
    for proc in psutil.process_iter():
        if proc.name().lower() == PROCNAME.lower():
            print(proc.exe())
            steam_path = proc.exe()
            print("Shutting down Steam...")
            subprocess.call([steam_path, "-shutdown"])

            steam_running = True
            while steam_running:
                steam_running = False
                for proc in psutil.process_iter():
                    if proc.name() == PROCNAME:
                        steam_running = True
                    
            print("Steam shutdown.")

    print("Starting Steam...")
    print(steam_path)
    os.system("start \"\" \"{}\" -silent -login {} {}".format(steam_path, username, password))

def find_bi_publisher():
    reg = winreg.ConnectRegistry(None, winreg.HKEY_CURRENT_USER)
    try:
        k = winreg.OpenKey(reg, r"Software\bohemia interactive\arma 3 tools")
        arma3tools_path = winreg.QueryValueEx(k, "path")[0]
        winreg.CloseKey(k)
    except:
        raise Exception("BadTools","Arma 3 Tools are not installed correctly or the P: drive needs to be created.")

    publisher_path = os.path.join(arma3tools_path, "Publisher", "PublisherCmd.exe")

    if os.path.isfile(publisher_path):
        return publisher_path
    else:
        raise Exception("BadTools","Arma 3 Tools are not installed correctly or the P: drive needs to be created.")

def steam_publish_folder(folder, mod_id, change_notes):
    cmd = [find_bi_publisher(), "update", "/id:{}".format(mod_id), "/changeNoteFile:{}".format(change_notes), "/path:{}".format(folder)]

    print ("running: {}".format(" ".join(cmd)))

    print("")
    print("Publishing folder {} to workshop ID {}".format(folder,mod_id))
    print("")

    ret = 17
    while ret != 0:
        if ret == 17 or ret == 19:
            print("Waiting for Steam to initialize...")
            time.sleep(30)
        else:
            print("publisher failed with code {}".format(ret))
            raise Exception("Publisher","Publisher had problems")
        ret = subprocess.call(cmd)
        print("Publisher Status: {}".format(ret))
       




def main(argv):
    try:
        parser = argparse.ArgumentParser(description="Arma Automatic Publishing Script")
        parser.add_argument('manifest', type=argparse.FileType('r'), help='manifest json file')
        parser.add_argument('-r', '--release_target', type=str, help="the name of the release target in the manifest file.", default="release")

        args = parser.parse_args()

        manifest_file = args.manifest
        release_target = args.release_target

        manifest = json.load(manifest_file)

        

        if(not "CBA_PUBLISH_CREDENTIALS_PATH" in os.environ):
            raise Exception("CBA_PUBLISH_CREDENTIALS_PATH is not set in the environment")

        credentials_path = os.environ["CBA_PUBLISH_CREDENTIALS_PATH"]
        
        
        for destination in manifest['publish'][release_target]['destinations']:
            cred_file = json.load(open(os.path.join(credentials_path, destination["cred_file"])))
            if(destination["type"] == "steam"):
                if("username" in cred_file and "password" in cred_file):
                    steam_username = cred_file["username"]
                    steam_password = cred_file["password"]
                    
                    start_steam_with_user(steam_username, steam_password)
                else:
                    raise Exception("Credentials file did not specify a username and password for Steam login")
                if(not "project_id" in destination):
                    raise Exception("Steam Publish","No project ID defined in manifest for Steam publish")
                project_id = destination["project_id"]

                if(not "release_dir" in destination):
                    raise Exception("Steam Publish","No release directory defined in manifest for Steam publish")
                release_dir = destination["release_dir"]

                if(not "release_text" in destination):
                    raise Exception("Steam Publish","No release text file defined in manifest for Steam publish")
                release_text = destination["release_text"]

                steam_publish_folder(release_dir, project_id, release_text)
            if(destination["type"] == "sftp"):
                if("username" in cred_file and "password" in cred_file):
                    sftp_username = cred_file["username"]
                    sftp_password = cred_file["password"]
                else:
                    raise Exception("Credentials file did not specify a username and password for SFTP login")

                if(not "hostname" in destination):
                    raise Exception("SFTP Publish","No hostname was defined for the SFTP site.")
                hostname = destination["hostname"]

                if(not "local_path" in destination):
                    raise Exception("SFTP Publish","No local path was defined for the SFTP upload.")
                local_path = destination["local_path"]

                if(not "remote_path" in destination):
                    raise Exception("SFTP Publish","No remote path was defined for the SFTP upload.")
                remote_path = destination["remote_path"]

                

                cnopts = pysftp.CnOpts()
                cnopts.hostkeys = None   
                sftp = pysftp.Connection(host=hostname, username=sftp_username, password=sftp_password, cnopts=cnopts)
                version = get_project_version("..\\addons\\\main\\script_version.hpp")
                local_path = local_path.format(major=version[0], minor=version[1], patch=version[2], build=version[3])
                remote_path = remote_path.format(major=version[0], minor=version[1], patch=version[2], build=version[3])
                
                sftp.put(local_path, remotepath=remote_path)
    except Exception as e:
        print(e)
        sys.exit(1)

if __name__ == "__main__":
    main(sys.argv)
