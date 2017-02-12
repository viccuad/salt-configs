{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

beets_recurse_files:
  file.recurse:
    - name: /home/{{ user }}/
    - source: salt://{{ slspath }}/files/
    - user: {{ user }}
    - group: {{ user }}
    - file_mode: 655
    - dir_mode: 755
    - include_empty: True
    - exclude_pat: .gitignore

beets_install:
  pkg.installed:
    - names:
      - beets

{% endif %}
{% endfor %}
