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

workstation_sourceslist:
  file.managed:
    - name: /etc/apt/sources.list
    - source: salt://{{ slspath }}/templates/sources.list

include:
  - users.sudo
  - users
  - profile.dotfiles
