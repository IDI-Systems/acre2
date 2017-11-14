#!/usr/bin/env python

import sys
import subprocess
import argparse
import os
import json
import re

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

def do_action(args, error_msg, error_handler=None, error_args=None, ignore_failure=False):
    if(subprocess.call(args) != 0):
        print("Error: {}".format(error_msg))
        if(error_handler != None):
            error_handler(error_args)
        # Return if ignoring failure, otherwise terminate the build
        if(ignore_failure):
            return False
        else:
            sys.exit(1)
    return True

def create_pull_request(args):
    repository = args[0]
    current = args[1]
    target = args[2]
    token = args[3]

    pull = {
        'title': 'Jenkins Automatic Merge Failure {} to {}!'.format(current, target),
        'head': current,
        'base': target,
        'body': "An automatic merge from the Jenkins build system has failed. This needs to be resolved as soon as possible."
        }

    pull_string = json.dumps(pull, separators=(',',':')).replace('"','\\"')

    curl_string = ' '.join(["curl", '-H "Authorization: token {}"'.format(token), "--request POST", "--data \"{}\"".format(pull_string), "https://api.github.com/repos/{}/pulls".format(repository)])
    print(curl_string)
    subprocess.call(curl_string)

parser = argparse.ArgumentParser(description="Jenkins CI System for Arma Projects Will execute a build and commit changes back into the current and target branches.")
parser.add_argument('repository', type=str, help='repository name in format owner/repo')
parser.add_argument('current_branch', type=str, help='the name of the current branch, can be supplied with a remote, ie: origin/release')
parser.add_argument('-t', '--target_branch', type=str, help="the targeted branch for merging changes during build, defaults to 'master'", default="master")
parser.add_argument('-r', '--release_target', type=str, help="the name of the release target in the manifest file.", default="release")
parser.add_argument('-m', '--make_arg', help="a list of args for make", action="append")


args = parser.parse_args()

repository = args.repository
current_branch = os.path.basename(args.current_branch)
target_branch = args.target_branch
release_target = args.release_target
make_args = ["python", "-u", "make.py"]
if(args.make_arg != None):
    make_args.extend(args.make_arg)

github_token = os.environ["IDI_GITHUB_TOKEN"]

print(current_branch)
do_action(["git", "checkout", current_branch], "Failed to checkout back into checked out branch '{}'".format(current_branch))
do_action(make_args, "Make failed")

# Get previous README.md if we are not building release (so GitHub front-page always has link to latest release)
if current_branch != "release-build":
    print("Reverting README.md on non-release branch")
    do_action(["git", "checkout", "../README.md"], "Failed to checkout previous README.md version.", None, None, True)

version = get_project_version("..\\addons\\\main\\script_version.hpp")
version_str = "{}.{}.{}.{}".format(version[0],version[1],version[2],version[3])
commit_message = "v{} - Build {}".format(version_str,os.environ["BUILD_NUMBER"])

do_action(["git", "commit", "-am", commit_message], "Failed to commit changes back into branch '{}'".format(current_branch))
do_action(["git", "push", "origin", current_branch], "Failed to push changes back into branch 'origin/{}'".format(current_branch))
do_action(["git", "checkout", target_branch], "Failed to checkout target branch '{}'".format(target_branch))
do_action(["git", "pull", "origin", target_branch], "Failed to update target branch from 'origin/{}'".format(target_branch))

status_ok = do_action(["git", "merge", current_branch], "Failed to merge '{}' into '{}', conflict exists.".format(current_branch, target_branch), create_pull_request, [repository, current_branch, target_branch, github_token], True)
if(status_ok): # Only diff and push if merge was successful
    do_action(["git", "diff"], "Diff failed to resolve '{}' and '{}' cleanly, conflict exists.".format(current_branch, target_branch))
    do_action(["git", "push", "origin", target_branch], "Failed to push changes back into branch 'origin/{}'".format(target_branch))

# Pass version in case merge failed above (publish.py would try to read pre-merge file)
do_action(["python", "-u", "publish.py", "..\\manifest.json", "-r", release_target, "-v", version_str], "Publish failed.")

sys.exit(0)
