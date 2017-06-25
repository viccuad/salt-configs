include:
  - users.sudo
  - users

offlinepc-packages:
  pkg.installed:
    - names:
      # For console and keyboard configuration:
      - console-data
      - keyboard-configuration
      # For checking GPG keys:
      - hopenpgp-tools
      # For backing up the keys:
      - paperkey
      - qrencode
      # For using and configuring the Yubikey:
      - python-yubico
      - python-yubico-tools
      - yubikey-personalization
      # For smartcards:
      - pcscd
      - scdaemon
      - pcsc-tools
      - gpgsm
      # For encrypted filesystems:
      - cryptsetup
      - libpam-mount
