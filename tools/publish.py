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
import tempfile

from uritemplate import URITemplate, expand

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
    os.system("start \"\" \"{}\" -silent -noverifyfiles -login {} {}".format(steam_path, username, password))

def close_steam():
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

def steam_publish_folder(folder, mod_id, version, steam_changelog):
    change_notes = steam_changelog.format(major=version[0], minor=version[1], patch=version[2], build=version[3])
    steam_changelog_filepath = "steam_changelog.txt"
    steam_changelog_file = open(steam_changelog_filepath, "w")
    steam_changelog_file.write(change_notes)
    steam_changelog_file.close()
    cmd = [find_bi_publisher(), "update", "/id:{}".format(mod_id), "/changeNoteFile:{}".format(steam_changelog_filepath), "/path:{}".format(folder)]

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
    os.remove(steam_changelog_filepath)




def main(argv):
    try:
        parser = argparse.ArgumentParser(description="Arma Automatic Publishing Script")
        parser.add_argument('manifest', type=argparse.FileType('r'), help='manifest json file')
        parser.add_argument('-r', '--release_target', type=str, help="the name of the release target in the manifest file.", default="release")

        args = parser.parse_args()

        manifest_file = args.manifest
        release_target = args.release_target

        manifest = json.load(manifest_file)
        version = get_project_version("..\\addons\\\main\\script_version.hpp")

        if(not "CBA_PUBLISH_CREDENTIALS_PATH" in os.environ):
            raise Exception("CBA_PUBLISH_CREDENTIALS_PATH is not set in the environment")

        credentials_path = os.environ["CBA_PUBLISH_CREDENTIALS_PATH"]
        
        
        for destination in manifest['publish'][release_target]['destinations']:
            
            if(destination["type"] == "steam"):
                cred_file = json.load(open(os.path.join(credentials_path, destination["cred_file"])))
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

                if(not "steam_changelog" in destination):
                    raise Exception("Steam Publish","No steam changelog defined in manifest for Steam publish")
                steam_changelog = destination["steam_changelog"]

                steam_publish_folder(release_dir, project_id, version, steam_changelog)
                close_steam()
            if(destination["type"] == "sftp"):
                cred_file = json.load(open(os.path.join(credentials_path, destination["cred_file"])))
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

                local_path = local_path.format(major=version[0], minor=version[1], patch=version[2], build=version[3])
                remote_path = remote_path.format(major=version[0], minor=version[1], patch=version[2], build=version[3])
                
                print("SFTP: Publishing {} to remote {}:{}".format(local_path, hostname, remote_path))
                
                sftp.put(local_path, remotepath=remote_path)
                print("SFTP: Upload Complete!")
            if(destination["type"] == "github"):

                account = destination["account"]
                tag_name = destination["tag_name"]
                branch = destination["branch"]
                name = destination["name"]
                body_file = destination["body_file"]
                local_path = destination["local_path"]
                prerelease = destination["prerelease"]
                asset_name = destination["asset_name"]
                
                tag_name = tag_name.format(major=version[0], minor=version[1], patch=version[2], build=version[3])
                name = name.format(major=version[0], minor=version[1], patch=version[2], build=version[3])
                asset_name = asset_name.format(major=version[0], minor=version[1], patch=version[2], build=version[3])
                local_path = local_path.format(major=version[0], minor=version[1], patch=version[2], build=version[3])

                release_text_file = open(body_file, mode='r')
                release_text = release_text_file.read()
                release_text_file.close()


                create_request = {
                    "tag_name": tag_name,
                    "target_commitish": branch,
                    "name": name,
                    "body": release_text,
                    "draft": False,
                    "prerelease": prerelease
                }

                github_token = os.environ["IDI_GITHUB_TOKEN"]

                release_string = json.dumps(create_request, separators=(',',':'))

                temp_dir = tempfile.mkdtemp()
                tmpname = os.path.join(temp_dir,"jsonpost")
                temp_file = open(tmpname, 'w')
                temp_file.write(release_string)
                temp_file.close()
                curl_string = ' '.join(["curl", '-s', '-H "Authorization: token {}"'.format(github_token), '-H "Content-Type: application/json"', "--request POST", "--data", '"@{}"'.format(tmpname).replace('\\','\\\\'), "https://api.github.com/repos/{}/releases".format(account)])

                print("Creating Github Release...")
                response = subprocess.check_output(curl_string)
                response_json = json.loads(response.decode("ascii"))
                shutil.rmtree(temp_dir)
                if("id" in response_json):
                    print("Github Release Created @ {}".format(response_json["url"]))
                    release_id = response_json["id"]
                    upload_url = response_json["upload_url"]

                    t = URITemplate(upload_url)
                    upload_url = t.expand(name=asset_name)


                    curl_string = ' '.join(["curl", '-s', '-H "Authorization: token {}"'.format(github_token),
                        '-H "Content-Type: application/zip"',
                        "--data-binary",
                        '"@{}"'.format(local_path),
                        upload_url])
                    print("Attaching Asset...")
                    response = subprocess.check_output(curl_string)
                    response_json = json.loads(response.decode("ascii"))
                    if("browser_download_url" in response_json):
                        print("Asset Attached @ {}".format(response_json["browser_download_url"]))
                    else:
                        print(response_json)
                        raise Exception("Github Publish","Failed to Attach Asset")
                    
                else:
                    print(response_json)
                    raise Exception("Github Publish","Failed to Create Release")

    except Exception as e:
        print(e)
        sys.exit(1)

if __name__ == "__main__":
    main(sys.argv)
