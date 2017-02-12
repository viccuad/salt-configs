{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

gnupg_recurse_files:
  file.recurse:
    - name: /home/{{ user }}/
    - source: salt://{{ slspath }}/files/
    - user: {{ user }}
    - group: {{ user }}
    - file_mode: 600
    - dir_mode: 700
    - include_empty: True
    - exclude_pat: .gitignore

gnupg_zshenv:
  file.append:
    - name: /home/{{ user }}/.zshenv
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
      - dirmngr
      - tor
      - hopenpgp-tools # check for problems in your key

gnupg_agent_sockets:
  # ensure that gpg-agent and dirmngr are always available (gpg 2.1)
  cmd.run:
    - names:
      - systemctl --user enable gpg-agent.socket
      - systemctl --user enable gpg-agent-ssh.socket
      - systemctl --user enable gpg-agent-restricted.socket
      - systemctl --user enable dirmngr.socket
    - runas: {{ user }}

gnupg_install_hkps_ca:
  # verify ca with https://sks-keyservers.net/verify_tls.php
  file.managed:
    - name: /usr/share/gnupg/sks-keyservers.netCA.pem
    - source: https://sks-keyservers.net/sks-keyservers.netCA.pem
    - source_hash: sha256=d14057d20ebfe26bbe1049896994f9c159b46ea0fa552d71dda366b2ec056f38

{% endif %}
{% endfor %}
