{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

virtualenv_recurse_files:
  file.recurse:
    - name: /home/{{ user }}/
    - source: salt://{{ slspath }}/files/
    - user: {{ user }}
    - group: {{ user }}
    - file_mode: 655
    - dir_mode: 755
    - include_empty: True
    - exclude_pat: .gitignore

virtualenv_zshrc:
  file.append:
    - name: /home/{{ user }}/.zshrc
    - text: |
            # virtualenvwrapper:
{% if grains['os_family'] == 'Debian' %}
            source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
{% elif grains['osrelease'] == '42.2' %}
            /usr/bin/virtualenvwrapper.sh
{% endif %}

virtualenv_zshaliases:
  file.append:
    - name: /home/{{ user }}/.zsh/aliases.zsh
    - text: |
            # virtualenvwrapper:
            alias mkvirtualenv="mkvirtualenv --system-site-packages"
            alias mkvirtualenv3="mkvirtualenv -p `which python3` --system-site-packages"

virtualenv_install:
  pkg.installed:
    - names:
{% if grains['os_family'] == 'Debian' %}
      - virtualenvwrapper
{% elif grains['osrelease'] == '42.2' %}
      - python-virtualenvwrapper
{% endif %}

{% endif %}
{% endfor %}
