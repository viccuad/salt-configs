workstation_sourceslist:
  file.managed:
    - name: /etc/apt/sources.list
    - source: salt://{{ slspath }}/templates/sources.list
  cmd.run:
    - names:
      - apt-get update

workstation_packages:
  pkg.installed:
    - names:
      - network-manager
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
