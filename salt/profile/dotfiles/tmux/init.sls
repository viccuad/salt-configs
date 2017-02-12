{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

tmux_recurse_files:
  file.recurse:
    - name: /home/{{ user }}/
    - source: salt://{{ slspath }}/files/
    - user: {{ user }}
    - group: {{ user }}
    - file_mode: 655
    - dir_mode: 755
    - include_empty: True
    - exclude_pat: .gitignore

tmux_zshaliases:
  file.append:
    - name: /home/{{ user }}/.zsh/aliases.zsh
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

{% endif %}
{% endfor %}
