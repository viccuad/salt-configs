{% set roles = salt['pillar.get']('roles', '') %}
{% set subroles = salt['pillar.get']('subroles', {}) %}
{% set domain = salt['pillar.get']('domain') %}
{% set id = salt['grains.get']('id') %}

base:
  '*':
    - common
  'id:{{ id }}':
    - match: grain
    - id.{{ id }}
{% for role in roles %}
  'roles:{{ role }}':
    - match: pillar
    - role.{{ role }}
{% endfor %}
{% for role,subrole in subroles.items() %}
  'subroles:{{ role }}:{{ subrole }}':
    - match: pillar
    - role.{{ role }}.{{ subrole }}
{% endfor %}
