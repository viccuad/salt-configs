base:
  '*':
    - profile.common
  'roles:workstation':
    - match: grain
    - profile.workstation
  'roles:laptop':
    - match: grain
    - profile.laptop
  'roles:desktopenv':
    - match: grain
    - profile.desktopenv
