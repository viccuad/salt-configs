{% set nested_container = salt['cmd.run']("systemd-detect-virt") %}
{% if nested_container == 'lxc' %}

# service will fail to start, fix by commenting out rlimits from
# `/etc/avahi/avahi-daemon.conf` and restarting the service:
avahi_lxc-fix:
  cmd.run:
    - names:
      - apt-get -y install avahi-daemon || true # fails because cannot start service
  service.running:
    - name: avahi-daemon
    - watch:
      - file: /etc/avahi/avahi-daemon.conf
  file.comment:
    - name: /etc/avahi/avahi-daemon.conf
    - regex: rlimit-

{% endif %}

freedombox_install:
  cmd.run:
    - names:
      - DEBIAN_FRONTEND=noninteractive apt-get -y install freedombox-setup
      - /usr/lib/freedombox/setup | tee /tmp/freedombox-setup.log

# TODO append to authorized_key instead of clearing it
