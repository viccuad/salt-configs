base:
  {{ grains.id }}:
  {% for state in pillar.get('states', []) %}
    - {{ state }}
  {% endfor %}
