#!/bin/sh

STATE=`nmcli networking connectivity`

if [ $STATE = 'full' ]
then
    ~/bin/msmtp-queue # send mail
    mbsync meviccuadme # sync mail # TODO does this sync mail back?
    notmuch new # find and import new messages to notmuch db, with tag `new`
    # TODO notmuch tag the maildir back with `notmuch tags`?
    afew --tag --new # run tag filters, operate on `new` messages
    # afew -v --tag --new
    # afew -v --move-mail # move mails between maildir folders depending on their tags
    exit 0
fi
echo "No internet connection."
exit 0