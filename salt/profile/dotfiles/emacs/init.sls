emacs_recurse_files:
  file.recurse:
    - name: /home/vic/
    - source: salt://{{ slspath }}/files/
    - user: vic
    - group: vic
    - file_mode: 655
    - dir_mode: 755
    - include_empty: True

emacs_zshenv_replace_editor:
  file.replace:
    - name: /home/vic/.zshenv
    - pattern: EDITOR='vim'
    - repl: EDITOR='emacsclient -nw'

emacs_zshenv:
  file.append:
    - name: /home/vic/.zshenv
    - text: |
            # emacs: make emacsclient start a server if there isn't one before:
            export ALTERNATE_EDITOR=""

emacs_zshaliases:
  file.append:
    - name: /home/vic/.zsh/aliases.zsh
    - text: |
            # emacs aliases:
            alias sm="TERM=xterm-256color emacsclient -t -c"

emacs_install:
  pkg.installed:
    - names:
      - emacs24
      - emacs-goodies-el
      - xclip
      - aspell
      - aspell-en
      - aspell-de
      - aspell-es
      # markdown layer:
      - markdown
      # c/c++ layer:
      - cscope
      # for ggtags (helm-ggtags):
      - global
      - exuberant-ctags
      # shell layer:
      - shellcheck
      - python3-bashate
      # python layer:
      - flake8
      - python-hacking
      - python3-hacking
      - hy
      # - autoflake missing in Debian
      # latex layer:
      - pandoc

emacs_clone_spacemacs:
  git.latest:
    - name: https://github.com/syl20bnr/spacemacs.git
    - target: /home/vic/.emacs.d
    - user: vic
    - require:
      - pkg: git
