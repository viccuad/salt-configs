{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

pass_zshaliases:
  file.append:
    - name: /home/{{ user }}/.zsh/aliases.zsh
    - text: |
            # pass aliases:
            alias passmenu='/usr/share/doc/pass/examples/dmenu/passmenu --type'

pass_install:
  pkg.installed:
    - names:
{% if grains['os_family'] == 'Debian' %}
      - pass
      - suckless-tools
      - xdotool
{% elif grains['osrelease'] == '42.2' %}
      - password-store
      - password-store-dmenu
{% endif %}

{% endif %}
{% endfor %}
