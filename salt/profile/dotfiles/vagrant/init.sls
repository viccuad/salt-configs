{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

include:
  - profile.dotfiles.lxc

vagrant_zshenv:
  file.append:
    - name: /home/{{ user }}/.zshenv
    - text: |
            # vagrant:
            export VAGRANT_DEFAULT_PROVIDER="lxc"
            # export VAGRANT_LOG=INFO

vagrant_install:
  pkg.installed:
    - names:
      - vagrant
      # - dnsmasq
      - bridge-utils
      - vagrant-lxc
    - require:
      - sls: profile.dotfiles.lxc  # because of vagrant-lxc

{% endif %}
{% endfor %}
