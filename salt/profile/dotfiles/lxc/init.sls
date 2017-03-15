{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

lxc_install:
  pkg.installed:
    - names:
      - lxc
      - bridge-utils

# https://wiki.debian.org/LXC/SimpleBridge#Using_lxc-net
lxc_config_lxc-net:
 file.managed:
    - name: /etc/default/lxc-net
    - source: salt://{{ slspath }}/templates/lxc-net.jinja
    - template: jinja

lxc_config_default_network:
 file.managed:
    - name: /etc/lxc/default.conf
    - source: salt://{{ slspath }}/templates/lxc-default-conf

# lxc-net creates the bridge on startup, adds masquerading and forward firewall
# rules using iptables2 calls
lxc_lxc-net_service:
  service.running:
    - name: lxc-net
    - enable: True
    - watch:
      - file: /etc/lxc/default.conf
      - file: /etc/default/lxc-net

{% endif %}
{% endfor %}
