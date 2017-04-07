{% set roles = salt['grains.get']('roles', '') %}
{% set subroles = salt['grains.get']('subroles', {}) %}
{% set id = salt['grains.get']('id') %}

base:
  '*':
    - common
  'id:{{ id }}':
    - match: grain
    - id.{{ id }}
{% for role in roles %}
  'roles:{{ role }}':
    - match: grain
    - role.{{ role }}
{% endfor %}
{% for role,subrole in subroles.items() %}
  'subroles:{{ role }}:{{ subrole }}':
    - match: grain
    - role.{{ role }}.{{ subrole }}
{% endfor %}
