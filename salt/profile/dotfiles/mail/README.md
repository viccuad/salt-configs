# Introduction

This is basically a local, FOSS gmail substitute, with tags capability.


```
                     +---+   +----------+       +----+   +-----+
                     |RSS|   |local mail|       |IMAP|   |MSMTP|
                     +-|-+   +----|-----+       +-|--+   +-----+
                       |          |               |         ^
              /        v          |               |         |
              |   +---------+     |               |         |
              |   |rss2email|     |               |         |
              |   +----|----+     |               |         |
              |        |          |               |         |
              |        +--------->|               |         |
              |                   v               v         |
              |                 +-----+       +------+   +--|--+
              |                 |exim4|       |mbysnc|   |msmtp|
              |                 +-|---+       +---|--+   +-----+
              |                   |               |         ^
automated     |                   v               |         |
   with      /|                                   |         |
 systemd     \|                 ~/.mail/* <-------+         |
   user       |                  Maildir                    |
  units       |                                             |
   and        |                   |                         |
checkmail.sh  |                   |                         |
              |                   v                         |
              |               +-------+                     |
              |               |notmuch|                     |
              |               +---|---+                     |
              |                   |                         |
              |                   v                         |
              |                 +----+                +-----|-----+
              |                 |afew|                |msmtp queue|
              |                 +-|--+                +-----------+
               \                  |                         ^
                                  |                         |
                                  |     +--------------+    |
                                  |     |+------------+|    |
                                  +---->||    MUA     ||----+
                                        ||(notmuch.el)||
                                        |+------------+|
                                        +--------------+
```

I use a Maildir-centric setup.
- [mbsync][2] is used to keep a local copy of my emails synchronised using
  IMAP, at `~/.mail/myaccount`
- Outgoing emails are sent using [msmtp][8] and the [msmtpq][9] script, back
  out via gandi.net's servers. The queue resides in `~/.msmtpqueue/*`
- local mail, from root and the local user, sent by `/usr/sbin/sendmail`, is
  processed by the default MTA configured, `exim4`. I have reconfigured `exim4`
  to deliver to `~/.mail/local`
- RSS feeds are processed by [rss2email][11], and delivered by local mail to the
  maildir
- The maildir is processed by [notmuch][6], which tags the emails and provides
  seaching
- Then the mail gets even more filtered by [afew][12]
- Mail is read from the Maildir by a notmuch-aware MUA ([notmuch emacs][6] in
  this case)


# Tags

clean -> [mbsync] -> arrives at maildir  -> [notmuch new] +tags: new ->
-> [afew --tag --new]


## Adapted from

https://bostonenginerd.com/posts/notmuch-of-a-mail-setup-part-1-mbsync-msmtp-and-systemd/
https://bostonenginerd.com/posts/notmuch-of-a-mail-setup-part-2-notmuch-and-emacs/
https://github.com/kzar/davemail
https://foobacca.co.uk/blog/2013/03/offlineimap-and-msmtp/
https://github.com/foobacca/dotfiles


# TODO

- [ ] Add spamassasin and/or classification to afew
- [ ] Fix systemd timers
- [ ] Fix caching of passwords (gpg with smartcard is a pain for cronjobs)
- [ ] Move mails with afew
- [ ] Add different mail configs (work, etc)
        https://foobacca.co.uk/blog/2013/03/notmuch/
- [ ] Filter mailing lists with RE
        https://foobacca.co.uk/blog/2013/07/matching-headers-with-regular-expressions-using-afew/
- [ ] Make a spacemacs layer out of it
        https://github.com/lehoff/dotfiles
        https://github.com/bgamari/spacemacs-config/blob/master/private/notmuch/packages.el
- [ ] Add Snippets for mail
        https://martinralbrecht.wordpress.com/2016/05/30/handling-email-with-emacs/
- [ ] Fix saving of Drafts


[1]: https://gandi.net
[2]: http://isync.sourceforge.net/mbsync.html
[3]: http://www.offlineimap.org
[4]: http://isync.sourceforge.net/mbsync.html#INHERENT%20PROBLEMS
[5]: https://github.com/kzar/emacs.d
[6]: https://notmuchmail.org/
[7]: https://www.emacswiki.org/emacs/GnusAlias
[8]: http://msmtp.sourceforge.net/
[9]: https://martinralbrecht.wordpress.com/2016/05/30/handling-email-with-emacs/
[10]: https://www.emacswiki.org/emacs/GnusMSMTP#toc3
[11]: https://tracker.debian.org/pkg/rss2email
[12]: https://github.com/afewmail/afew
