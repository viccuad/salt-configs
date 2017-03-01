#!/bin/sh

STATE=`nmcli networking connectivity`

if [ $STATE = 'full' ]
then
    ~/bin/msmtp-queue # send mail
    mbsync meviccuadme # sync mail
    notmuch new # find and import new messages to notmuch db
    afew -v --tag --new
    # afew -v --move-mail
    exit 0
fi
echo "No internet connection."
exit 0
