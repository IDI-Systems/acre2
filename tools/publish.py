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

if sys.platform == "win32":
    import winreg

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
    
    parser = argparse.ArgumentParser(description="Arma Automatic Publishing Script")
    parser.add_argument('manifest', type=argparse.FileType('r'), help='manifest json file')

    args = parser.parse_args()

    manifest_file = args.manifest

    manifest = json.load(manifest_file)
    
    for destination in manifest['publish']['destinations']:
        if(destination["type"] == "steam"):
            if("login_var" in destination and "password_var" in destination):
                login_var = destination["login_var"]
                password_var = destination["password_var"]
                steam_login = ""
                steam_password = ""
                if(login_var in os.environ):
                    steam_login = os.environ[login_var]
                else:
                    raise Exception("Steam Login","No Steam login environment variable found for {}".format(login_var))

                if(password_var in os.environ):
                    steam_password = os.environ[password_var]
                else:
                    raise Exception("Steam Login","No Steam password environment variable found for {}".format(password_var))
                
                start_steam_with_user(steam_login, steam_password)
            else:
                raise Exception("Steam Login","Manifest did not specify the environment variables for Steam login and password")
            
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



if __name__ == "__main__":
    main(sys.argv)
