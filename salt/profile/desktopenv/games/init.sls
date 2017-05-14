{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

games_enable_multiarch:
  cmd.run:
    - names:
      - dpkg --add-architecture i386

games_steam_license:
  cmd.run:
    - unless: which steam
    - name: '/bin/echo /usr/bin/debconf steam/license note | /usr/bin/debconf-set-selections'

games_steam_question:
  cmd.run:
    - unless: which steam
    - name: '/bin/echo /usr/bin/debconf steam/question select "I AGREE" | /usr/bin/debconf-set-selections'
    - require:
      - cmd: games_steam_license

games_install_steam:
  pkg.installed:
    - names:
      - steam

games_install:
  pkg.installed:
    - names:
      - steam-devices
games_recurse_files:
  file.recurse:
    - name: /home/{{ user }}/
    - source: salt://{{ slspath }}/files/
    - user: {{ user }}
    - group: {{ user }}
    - file_mode: 655
    - dir_mode: 755
    - include_empty: True
    - exclude_pat: .gitignore

{% endif %}
{% endfor %}
