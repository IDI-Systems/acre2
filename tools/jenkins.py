#!/usr/bin/env python

import sys
import subprocess
import argparse
import os
import json

def do_action(args, error_msg, error_handler=None, error_args=None):
    if(subprocess.call(args) != 0):
        print("Error: {}".format(error_msg))
        if(error_handler != None):
            error_handler(error_args)
        sys.exit(1)

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
parser.add_argument('-r', '--release_target', type=str, help="the name of the release target in the manifest file.", default="publish")


args = parser.parse_args()

repository = args.repository
current_branch = os.path.basename(args.current_branch)
target_branch = args.target_branch
release_target = args.release_target
github_token = os.environ["IDI_GITHUB_TOKEN"]

print(current_branch)

do_action(["git", "checkout", current_branch], "Failed to checkout back into checked out branch '{}'".format(current_branch))
do_action(["python", "make.py", "--ci", "version","increment_build","compile","force","check_external","release"], "Make failed")
do_action(["git", "commit", "-am", "Build Increment {}".format(os.environ["BUILD_NUMBER"])], "Failed to commit changes back into branch '{}'".format(current_branch))
do_action(["git", "push", "origin", current_branch], "Failed to push changes back into branch 'origin/{}'".format(current_branch))
do_action(["git", "checkout", target_branch], "Failed to checkout target branch '{}'".format(target_branch))
do_action(["git", "pull", "origin", target_branch], "Failed to update target branch from 'origin/{}'".format(target_branch))
do_action(["git", "merge", current_branch], "Failed to merge '{}' into '{}', conflict exists.".format(current_branch, target_branch), create_pull_request, [repository, current_branch, target_branch, github_token])
do_action(["git", "diff"], "Diff failed to resolve '{}' and '{}' cleanly, conflict exists.".format(current_branch, target_branch))
do_action(["git", "push", "origin", target_branch], "Failed to push changes back into branch 'origin/{}'".format(target_branch))
do_action(["python", "publish.py", "..\\manifest.json", release_target], "Publish failed.")

sys.exit(0)
