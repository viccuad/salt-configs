{% for user, details in pillar.get('users', {}).items() %}
{% if 'users' in details['groups'] %}

tlp_zshaliases:
  file.append:
    - name: /home/{{ user }}/.zsh/aliases.zsh
    - text: |
            # tlp aliases:
            alias charge-batteries-totally="sudo tlp fullcharge BAT0; sudo tlp fullcharge BAT1"

tlp_install:
  pkg.installed:
    - names:
      - tlp
      - tp-smapi-dkms
      - acpi-call-dkms

tlp_config:
  file.managed:
    - name: /etc/default/tlp
    - source: salt://{{ slspath }}/templates/tlp

{% endif %}
{% endfor %}
