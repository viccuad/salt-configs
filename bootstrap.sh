#! /usr/bin/env bash

echo "Notice: $0 needs to be run with admin permissions"
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -s|--symlink)
            echo "Symlinking.."
            ln -s -f "$(pwd)"/salt /srv/salt
            ln -s -f "$(pwd)"/pillar /srv/pillar
            ln -s -f "$(pwd)"/etc/minion /etc/salt/minion
            shift # past argument
            ;;
        -h|--help)
            echo "Usage: $0 [-s | --symlink]  [-h | --help]"
            echo "Bootstrap all needed configuration, dependencies, and unitfiles for Salt"
            echo "Possible options:"
            echo "    symlink     Symlink salt configurations to this system"
            echo "    help        Show this message"
            exit
            ;;
        *)
            # unknown option
            ;;
    esac
    shift # past argument or value
done

if [[ -r /etc/os-release ]]; then
    . /etc/os-release
    if [[ $ID = ubuntu || $ID = debian ]]; then
        echo "Debian or Ubuntu distribution detected"

        echo "Updating repos.."
        apt-get -y update

        echo "Installing dependencies.."
        # install gitpython instead of pygit2 to be able to use gitfs
        # See https://github.com/libgit2/pygit2/issues/644
        # don't override locally installed config files
        apt-get -y -o Dpkg::Options::="--force-confdef" \
                -o Dpkg::Options::="--force-confold" install git-core python-git salt-minion

        echo "Disabling salt-minion service.."
        # salt-minion service shouldn't be running, as we have no master:
        systemctl stop salt-minion
        systemctl disable salt-minion
    fi
else
    echo "Not in a distribution with /etc/os-release available"
    exit
fi

echo "Done!"
