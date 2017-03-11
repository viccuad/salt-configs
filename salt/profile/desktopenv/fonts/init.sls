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

fonts_reload_cache:
  cmd.run:
    - names:
      - fc-cache -f

{% endif %}
{% endfor %}
