include:
  - users.sudo
  - users
  # For gpg-agent setup:
  - profile.dotfiles.gnupg

offlinepc-packages:
  pkg.installed:
    - name: paperkey
    - name: qrencode
    - name: python-yubico
    - name: python-yubico-tools
    - name: yubikey-personalization
    # - name: pcsd TODO
    - name: scdaemon
    - name: gpgsm
    - name: cryptsetup
    - name: libpam-mount
