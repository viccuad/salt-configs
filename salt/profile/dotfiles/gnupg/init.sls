gnupg_recurse_files:
  file.recurse:
    - name: /home/vic/
    - source: salt://{{ slspath }}/files/
    - user: vic
    - group: vic
    - file_mode: 655
    - dir_mode: 755
    - include_empty: True
    - exclude_pat: .gitignore

gnupg_zshenv:
  file.append:
    - name: /home/vic/.zshenv
    - text: |
            # From gpg-agent manual (for gpg 2.1)
            GPG_TTY=$(tty)
            export GPG_TTY
            # Tell ssh that we are using gpg-agent for ssh:
            unset SSH_AGENT_PID
            if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
                export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
            fi

gnupg_install:
  pkg.installed:
    - names:
      - gnupg-curl # support for HKPS keyservers
