{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

include:
  - profile.dotfiles.emacs

mail_recurse_files:
  file.recurse:
    - name: /home/{{ user }}/
    - source: salt://{{ slspath }}/files/
    - user: {{ user }}
    - group: {{ user }}
    - file_mode: keep
    # - dir_mode: keep
    - include_empty: True
    - exclude_pat: .gitignore
    - template: jinja

mail_install:
  pkg.installed:
    - names:
      - notmuch
      - isync #this is mbsync
      # - elpa-notmuch
      - msmtp
      - netcat # for msmtp connection testing
      - python-notmuch
      - python3-notmuch
      - afew
      - dbacl # for afew --update-reference
      - logrotate
      - rss2email
    - require:
      - sls: profile.dotfiles.emacs
      - pkg: network-manager

mail_install_certificate:
  cmd.run:
    - name: openssl s_client -connect mail.gandi.net:993 -showcerts 2>&1 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | sed -ne '1,/-END CERTIFICATE-/p' > /home/{{ user }}//.cert/webmail.gandi.net.pem
  file.managed:
    - name: /home/{{ user }}/.cert/webmail.gandi.net.pem
    - mode: 600
    - user: {{ user }}
    - group: {{ user }}
    - source_hash: sha256=b27eef8a5ea176df292599ac50d7aa3dd19ec5f6ef02c3b76ead3f478af6c2d4

mail_install_checkmail:
  file.managed:
    - name: /home/{{ user }}/.local/bin/checkmail.sh
    - mode: 744
    - user: {{ user }}
    - group: {{ user }}

mail_install_msmtpq:
  cmd.run:
    - name: "gunzip -c /usr/share/doc/msmtp/examples/msmtpq/msmtpq.gz > /home/{{ user }}/.local/bin/msmtpq"
  file.managed:
    - name: /home/{{ user }}/.local/bin/msmtpq
    - mode: 744
    - user: {{ user }}
    - group: {{ user }}

mail_install_msmtpqueue:
  file.managed:
    - name: /home/{{ user }}/.local/bin/msmtp-queue
    - source: /usr/share/doc/msmtp/examples/msmtpq/msmtp-queue
    - mode: 744
    - user: {{ user }}
    - group: {{ user }}

mail_configure_msmtpq:
  file.replace:
    - name: /home/{{ user }}/.local/bin/msmtpq
    - pattern: ^LOG=~/log/msmtp.queue.log
    - repl: LOG=~/.local/share/logs/msmtp.queue.log
    - backup: False
  # TODO disable network checking, leave it to the systemd unit

mail_configure_msmtp-queue:
  file.replace:
    - name: /home/{{ user }}/.local/bin/msmtp-queue
    - pattern: exec msmtpq
    - repl: exec /home/{{ user }}/bin/msmtpq
    - backup: False

mail_enable_logrotate:
  file.symlink:
    - name: /home/{{ user }}/.config/systemd/user/default.target.wants/msmtpq-rotate.service
    - target: /home/{{ user }}/.config/systemd/user/msmtpq-rotate.service
    - user: {{ user }}
    - group: {{ user }}
    - makedirs: True
    - require:
      - pkg: logrotate

mail_enable_afew_monthly:
  file.symlink:
    - name: /home/{{ user }}/.config/systemd/user/default.target.wants/afew_monthly.timer
    - target: /home/{{ user }}/.config/systemd/user/afew_monthly.timer
    - user: {{ user }}
    - group: {{ user }}
    - makedirs: True

mail_enable_afew_weekly:
  file.symlink:
    - name: /home/{{ user }}/.config/systemd/user/default.target.wants/afew_weekly.timer
    - target: /home/{{ user }}/.config/systemd/user/afew_weekly.timer
    - user: {{ user }}
    - group: {{ user }}
    - makedirs: True

mail_enable_checkmail:
  file.symlink:
    - name: /home/{{ user }}/.config/systemd/user/default.target.wants/checkmail.timer
    - target: /home/{{ user }}/.config/systemd/user/checkmail.timer
    - user: {{ user }}
    - group: {{ user }}
    - makedirs: True

mail_exim4_configure:
  # Configure exim4, which is what /usr/sbin/sendmail uses, to ~/.mail/local
  # maildir.
  # this would be better done with debconf, but seems buggy
  file.recurse:
    - name: /etc/exim4/
    - source: salt://{{ slspath }}/templates/
    - file_mode: keep
    - template: jinja
  cmd.run:
    - name: dpkg-reconfigure --frontend noninteractive exim4-config

mail_localmail_configure:
  # Sent root mails to the user:
  file.append:
    - name: /etc/aliases
    - text: |
            root: {{ user }}
{% endif %}
{% endfor %}
