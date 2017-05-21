include:
  - users.sudo
  - users

{% if grains['os_family'] == 'Debian' %}
workstation_sourceslist:
  file.managed:
    - name: /etc/apt/sources.list
    - source: salt://{{ slspath }}/templates/sources.list
  cmd.run:
    - names:
      - apt-get update
{% endif %}

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
      - dict
