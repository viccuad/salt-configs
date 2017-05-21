{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

signing-party_recurse_files:
  file.recurse:
    # rest of the files
    - name: /home/{{ user }}/
    - source: salt://{{ slspath }}/files/
    - user: {{ user }}
    - group: {{ user }}
    - file_mode: 655
    - dir_mode: 755
    - include_empty: True
    - exclude_pat: .gitignore

signing-party_recurse_files_caff:
  file.recurse:
    # .caff is like ~/.gnupg
    - name: /home/{{ user }}/.caff
    - source: salt://{{ slspath }}/files/.caff
    - user: {{ user }}
    - group: {{ user }}
    - file_mode: 600
    - dir_mode: 700
    - include_empty: True
    - exclude_pat: .gitignore
  require:
    - sls: signing-party_recurse_files

signing-party_install:
  pkg.installed:
    - names:
      - signing-party

{% endif %}
{% endfor %}
