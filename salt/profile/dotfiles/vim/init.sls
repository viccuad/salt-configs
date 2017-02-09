vim_recurse_files:
  file.recurse:
    - name: /home/vic/
    - source: salt://{{ slspath }}/files/
    - user: vic
    - group: vic
    - file_mode: 655
    - dir_mode: 755
    - include_empty: True

vim_zshenv:
  file.append:
    - name: /home/vic/.zshenv
    - text: |
            # vim:
            export SUDO_EDITOR="vim"
            export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
