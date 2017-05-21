{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

weechat_recurse_files:
  file.recurse: # TODO copies files at the end of symlink, bug
    - name: /home/{{ user }}/
    - source: salt://{{ slspath }}/files/
    - user: {{ user }}
    - group: {{ user }}
    - file_mode: 655
    - dir_mode: 755
    - keep_symlinks: True # for autoloads of plugins
    - include_empty: True
    - exclude_pat: .gitignore

weechat_install:
  pkg.installed:
    - names:
      - weechat
      - weechat-plugins
      - weechat-scripts
      - logrotate
      # for matrix plugin:
      - lua-cjson
      # for notifications:
      - libnotify-bin

weechat_enable_logrotate:
  file.symlink:
    - name: /home/{{ user }}/.config/systemd/user/default.target.wants/weechat-rotate.service
    - target: /home/{{ user }}/.config/systemd/user/weechat-rotate.service
    - user: {{ user }}
    - group: {{ user }}
    - makedirs: True
    - require:
      - pkg: logrotate

{% endif %}
{% endfor %}
