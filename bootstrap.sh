#! /usr/bin/env bash

# install gitpython instead of pygit2 to be able to use gitfs
# See https://github.com/libgit2/pygit2/issues/644
apt-get -y update
apt-get -y install git-core python-git salt-minion

# salt-minion service shouldn't be running, as we have no master:
systemctl stop salt-minion && sudo systemctl disable salt-minion
