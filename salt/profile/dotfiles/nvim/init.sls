{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

nvim_recurse_files:
  file.recurse:
    - name: /home/{{ user }}/
    - source: salt://{{ slspath }}/files/
    - user: {{ user }}
    - group: {{ user }}
    - file_mode: 655
    - dir_mode: 755
    - include_empty: True
    - exclude_pat: .gitignore

nvim_zshenv:
  file.append:
    - name: /home/{{ user }}/.zshenv
    - text: |
            # nvim:
            export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
            export NVIM_TUI_ENABLE_TRUE_COLOR=1

nvim_zshaliases:
  file.append:
    - name: /home/{{ user }}/.zsh/aliases.zsh
    - text: |
            # nvim aliases:
            alias nv="nvim"
            # Open last modified file in vim
            alias nVim="nvim `ls -t | head -1`"
            # Open a server instance of vim
            alias nvis="nvim --servername VIM"
            # Open vim in secure mode: no .vimrc and no plugins
            alias nvimmin="nvim -u ~/.config/nvim/minimal_init.vim"

nvim_install:
  pkg.installed:
    - names:
      - neovim
      # not present in Stretch: TODO
      # - python-neovim
      # - python-neovim-gui

{% endif %}
{% endfor %}
