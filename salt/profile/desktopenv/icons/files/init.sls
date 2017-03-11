{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

icons_install_paper:
  git.latest:
    - name: https://github.com/snwh/paper-icon-theme.git
    - target: /tmp/
    - user: {{ user }}
    - require:
      - pkg: git
  cmd.run:
    - names:
      - rm -rf /home/{{ user }}/.icons/Paper*
      - cp -rf /tmp/paper-icon-theme/Paper /home/{{ user }}/.icons./
      - cp -rf /tmp/paper-icon-theme/Paper-Mono-Dark /home/{{ user }}/.icons./

{% endif %}
{% endfor %}
