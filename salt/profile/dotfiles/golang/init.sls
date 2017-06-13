{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

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
      - go get -u -v github.com/golang/lint/golint
      - go get -u -v github.com/rogpeppe/godef
      - go get -u -v golang.org/x/tools/cmd/guru
      - go get -u -v golang.org/x/tools/cmd/gorename
      - go get -u -v golang.org/x/tools/cmd/goimports
      - go get -u -v golang.org/x/tools/cmd/godoc
      - go get -u -v github.com/kisielk/errcheck
      - go get -u -v github.com/mdempsky/unconvert
      - go get -u -v github.com/alecthomas/gometalinter && gometalinter --install --update
    - runas: {{ user }}
    - env:
      - GOPATH: '/home/{{ user }}//code/go'

{% endif %}
{% endfor %}
