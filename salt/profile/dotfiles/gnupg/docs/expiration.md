https://blog.josefsson.org/2014/08/26/the-case-for-short-openpgp-key-validity-periods/

1. In the offline computer:
    $ export GNUPGHOME=/path/to/.gnupg
    $ gpg --edit-key <keyid>
        >expire for every key and subkey
        >save
    $ gpg -a --export <keyid> > updated-key.txt

2. In the online computer:
    $ cat updated-key.txt |gpg --list-packets | head -20
    $ gpg --import updated_key.txt
    $ gpg --send-key <keyid>
    Update viccuad.me/assets/public_key.txt
