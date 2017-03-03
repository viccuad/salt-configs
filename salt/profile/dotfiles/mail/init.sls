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
      - elpa-notmuch
      - msmtp
      - netcat # for msmtp connection testing
      - python-notmuch
      - python3-notmuch
      - afew
    - require:
      - sls: profile.dotfiles.emacs

mail_install_checkmail:
  file.managed:
    - name: /home/{{ user }}/bin/checkmail.sh
    - mode: 744
    - user: {{ user }}
    - group: {{ user }}

mail_install_msmtpq:
  cmd.run:
    - name: "gunzip -c /usr/share/doc/msmtp/examples/msmtpq/msmtpq.gz > /home/{{ user }}/bin/msmtpq"
  file.managed:
    - name: /home/{{ user }}/bin/msmtpq
    - mode: 744
    - user: {{ user }}
    - group: {{ user }}

mail_install_msmtpqueue:
  file.managed:
    - name: /home/{{ user }}/bin/msmtp-queue
    - source: /usr/share/doc/msmtp/examples/msmtpq/msmtp-queue
    - mode: 744
    - user: {{ user }}
    - group: {{ user }}

mail_configure_msmtpq:
  file.replace:
    - name: /home/{{ user }}/bin/msmtpq
    - pattern: ^LOG=~/log/msmtp.queue.log
    - repl: LOG=~/.local/share/logs/msmtp.queue.log
    - backup: False

mail_configure_msmtp-queue:
  file.replace:
    - name: /home/{{ user }}/bin/msmtp-queue
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

{% endif %}
{% endfor %}
