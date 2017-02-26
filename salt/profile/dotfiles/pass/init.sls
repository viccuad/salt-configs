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
      - pass
      - suckless-tools
      - xdotool

{% endif %}
{% endfor %}
