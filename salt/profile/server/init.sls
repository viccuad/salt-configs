# TODO fail2ban for sshd
# TODO firewall only with ssh enabled

# disable root logins

server_sourceslist:
  file.managed:
    - name: /etc/apt/sources.list
    - source: salt://{{ slspath }}/templates/sources.list
  cmd.run:
    - names:
      - apt-get update

unattended-upgrades:
  pkg.installed:
    - name: unattended-upgrades
  debconf.set:
    - data:
        'unattended-upgrades/enable_auto_updates':
          type: boolean
          value: "true"
  cmd.wait:
    - name: "dpkg-reconfigure unattended-upgrades"
    - watch:
      - debconf: unattended-upgrades
    - env:
        DEBIAN_FRONTEND: noninteractive
        DEBCONF_NONINTERACTIVE_SEEN: "true"
