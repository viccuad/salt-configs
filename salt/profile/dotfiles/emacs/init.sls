{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

emacs_recurse_files:
  file.recurse:
    - name: /home/{{ user }}/
    - source: salt://{{ slspath }}/files/
    - user: {{ user }}
    - group: {{ user }}
    - file_mode: 655
    - dir_mode: 755
    - include_empty: True
    - exclude_pat: .gitignore

emacs_zshenv_replace_editor:
  file.replace:
    - name: /home/{{ user }}/.zshenv
    - pattern: EDITOR='vim'
    - repl: EDITOR="emacsclient -c"
    - backup: False

emacs_zshenv:
  file.append:
    - name: /home/{{ user }}/.zshenv
    - text: |
            # emacs: make emacsclient start a server if there isn't one before:
            export ALTERNATE_EDITOR=""

emacs_zshaliases:
  file.append:
    - name: /home/{{ user }}/.zsh/aliases.zsh
    - text: |
            # emacs aliases:
            alias e="emacsclient -t -c"

emacs_install:
  pkg.installed:
    - names:
      - emacs25-nox # non-gui
      - emacs25-common-non-dfsg
      - emacs-goodies-el
      - xclip
      - aspell
      - aspell-en
      - aspell-de
      - aspell-es
      - python3-proselint
      # markdown layer:
      - markdown
      # c/c++ layer:
      - gcc
      - cppcheck
      - cscope
      - clang
      - clang-format
      - clang-tidy
      - global # for ggtags (helm-ggtags):
      - exuberant-ctags
      - pkg-config
      # shell layer:
      - shellcheck
      - python3-bashate
      # python layer:
        # - flake8 using pylint instead, because it is broken for now
      - pylint
      - pylint3
      - python-jedi
      - python3-jedi
      - python-hacking
      - python3-hacking
      - hy
      - yapf
      - yapf3
      # - autoflake missing in Debian
      # latex layer:
      - pandoc
  cmd.run:
    - names:
      # python layer:
      - apt-get -y install python-pylint-*
      - apt-get -y install python3-pylint-*

emacs_clone_spacemacs:
  git.latest:
    - name: https://github.com/syl20bnr/spacemacs.git
    - target: /home/{{ user }}/.emacs.d
    - user: {{ user }}
    - require:
      - pkg: git

{% endif %}
{% endfor %}
