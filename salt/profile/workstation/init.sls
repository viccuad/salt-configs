workstation_packages:
  pkg.installed:
    - names:
      - vim
      - build-essential
      - git
      - grep
      - htop
      - silversearcher-ag

include:
  - users.sudo
  - users
  - profile.dotfiles
