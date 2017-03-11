{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

fonts_recurse_files:
  file.recurse:
    - name: /home/{{ user }}/
    - source: salt://{{ slspath }}/files/
    - user: {{ user }}
    - group: {{ user }}
    - file_mode: 644
    - dir_mode: 755
    - include_empty: True
    - exclude_pat: .gitignore
    - keep_symlinks: True


icons_install_paper:
  git.latest:
    - name: https://github.com/snwh/paper-icon-theme.git
    - target: /home/{{ user }}/.icons/Paper
    - user: {{ user }}
    - require:
      - pkg: git


{% endif %}
{% endfor %}
