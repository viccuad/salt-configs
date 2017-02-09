tmux_recurse_files:
  file.recurse:
    - name: /home/vic/
    - source: salt://{{ slspath }}/files/
    - user: vic
    - group: vic
    - file_mode: 655
    - dir_mode: 755
    - include_empty: True
tmux_zshaliases:
  file.append:
    - name: /home/vic/.zsh/aliases.zsh
    - text: |
            # tmux aliases:
            alias tmuxa='tmux attach -t'
            alias tmuxs='tmux new-session -s'
            alias tmuxl='tmux list-sessions'

tmux_install:
  pkg.installed:
    - names:
      - tmux
      - ncurses-term # for the tmux-256color terminfo
      - xsel
