{% if grains['os_family'] == 'Debian' %}

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
    - template: jinja

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
      - scdaemon
      - dirmngr
      - tor
      - hopenpgp-tools # check for problems in your key

gnupg_enable_gpg-agent_socket:
  file.symlink:
    - name: /home/{{ user }}/.config/systemd/user/sockets.target.wants/gpg-agent.socket
    - target: /usr/lib/systemd/user/gpg-agent.socket
    - user: {{ user }}
    - group: {{ user }}
    - makedirs: True

gnupg_enable_gpg-agent-ssh_socket:
  file.symlink:
    - name: /home/{{ user }}/.config/systemd/user/sockets.target.wants/gpg-agent-ssh.socket
    - target: /usr/lib/systemd/user/gpg-agent-ssh.socket
    - user: {{ user }}
    - group: {{ user }}
    - makedirs: True

gnupg_enable_gpg-agent-restricted_socket:
  file.symlink:
    - name: /home/{{ user }}/.config/systemd/user/sockets.target.wants/gpg-agent-restricted.socket
    - target: /usr/lib/systemd/user/gpg-agent-restricted.socket
    - user: {{ user }}
    - group: {{ user }}
    - makedirs: True

gnupg_enable_dirmngr_socket:
  file.symlink:
    - name: /home/{{ user }}/.config/systemd/user/sockets.target.wants/dirmngr.socket
    - target: /usr/lib/systemd/user/dirmngr.socket
    - user: {{ user }}
    - group: {{ user }}
    - makedirs: True

gnupg_install_hkps_ca:
  # verify ca with https://sks-keyservers.net/verify_tls.php
  file.managed:
    - name: /usr/share/gnupg/sks-keyservers.netCA.pem
    - source: https://sks-keyservers.net/sks-keyservers.netCA.pem
    - source_hash: sha256=0666ee848e03a48f3ea7bb008dbe9d63dfde280af82fb4412a04bf4e24cab36b

gnupg_forwarding_sshd:
  file.append:
    - name: /etc/ssh/sshd_config
    - text: |
            # for gpg forwarding over ssh. Enable automatic removal of stale
            # sockets when connecting to the remote machine. Otherwise you will
            # first have to remove the socket on the remote machine before
            # forwarding works:
            StreamLocalBindUnlink yes
    # only if server installed:
    - onlyif:
      - dpkg -s openssh-server

gnupg_install_remotegpg:
  file.managed:
    - name: /home/{{ user }}/.local/bin/remote-gpg
    - mode: 744
    - user: {{ user }}
    - group: {{ user }}

gnupg_restore_publickey:
  file.recurse:
    - name: /tmp/publickey
    - source: salt://{{ slspath }}/publickey/
  cmd.run:
    - names:
      - gpg --import /tmp/publickey/viccuad-public-gpg.key
      - gpg --import-ownertrust /tmp/publickey/viccuad-ownertrust-gpg.txt
    - runas: {{ user }}
      # to import, do:
      # gpg -a --export 0xA2591E231E251F36 > viccuad-public-gpg.key
      # gpg --export-ownertrust > viccuad-ownertrust-gpg.txt

{% endif %}
{% endfor %}

{% endif %}
