{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

golang_recurse_files:
  file.recurse:
    - name: /home/{{ user }}/
    - source: salt://{{ slspath }}/files/
    - user: {{ user }}
    - group: {{ user }}
    - file_mode: 655
    - dir_mode: 755
    - include_empty: True
    - exclude_pat: .gitignore

golang_zshenv:
  file.append:
    - name: /home/{{ user }}/.zshenv
    - text: |
            # go:
            export GOPATH="$HOME/code/go"

golang_zshenv_replace_path:
  file.replace:
    - name: /home/{{ user }}/.zshenv
    - pattern: '\$PATH:'
    - repl: '$PATH:$HOME/code/go/bin:'
    - backup: False

golang_install:
  pkg.installed:
    - names:
      - golang
      - gocode
  # deps that aren't packaged yet:
  cmd.run:
    - names:
      - go get -u -v github.com/rogpeppe/godef
      - go get -u -v golang.org/x/tools/cmd/guru
      - go get -u -v golang.org/x/tools/cmd/gorename
      - go get -u -v golang.org/x/tools/cmd/goimports
    - runas: {{ user }}
    - env:
      - GOPATH: '/home/{{ user }}//code/go'

{% endif %}
{% endfor %}
