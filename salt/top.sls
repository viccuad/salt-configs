base:
  '*':
    - profile.common
  'roles:workstation':
    - match: grain
    - profile.workstation
