{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

firewalld_recurse_files:
  file.recurse:
    - name: /home/{{ user }}/
    - source: salt://{{ slspath }}/files/
    - user: {{ user }}
    - group: {{ user }}
    - file_mode: 655
    - dir_mode: 755
    - include_empty: True
    - exclude_pat: .gitignore

firewalld_recurse_configs:
  file.recurse:
    - name: /etc/firewalld/
    - source: salt://{{ slspath }}/firewalld-configs/
    - file_mode: 655
    - dir_mode: 755
    - include_empty: True

firewalld_install:
  pkg.installed:
    - names:
      - firewall-applet
      - firewall-config

{% endif %}
{% endfor %}
