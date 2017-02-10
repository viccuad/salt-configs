zsh_recurse_files:
  file.recurse:
    - name: /home/vic/
    - source: salt://{{ slspath }}/files/
    - user: vic
    - group: vic
    - file_mode: 655
    - dir_mode: 755
    - include_empty: True
    - exclude_pat: .gitignore
    - require:
        - pkg: git # for git-prompt

zsh_install:
  pkg.installed:
    - names:
      - zsh
      - trash-cli
      - zsh-syntax-highlighting
      - autojump
