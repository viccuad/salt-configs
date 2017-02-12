{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

vim_recurse_files:
  file.recurse:
    - name: /home/{{ user }}/
    - source: salt://{{ slspath }}/files/
    - user: {{ user }}
    - group: {{ user }}
    - file_mode: 655
    - dir_mode: 755
    - include_empty: True
    - exclude_pat: .gitignore

vim_zshenv:
  file.append:
    - name: /home/{{ user }}/.zshenv
    - text: |
            # vim:
            export SUDO_EDITOR="vim"
            export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

{% endif %}
{% endfor %}
