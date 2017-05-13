base:
  '*':
    - profile.common
  'roles:workstation':
    - match: pillar
    - profile.workstation
  'roles:laptop':
    - match: pillar
    - profile.laptop
  'roles:desktopenv':
    - match: pillar
    - profile.desktopenv
  'roles:server':
    - match: pillar
    - profile.server
  'roles:freedombox':
    - match: pillar
    - profile.freedombox
  'roles:offlinepc':
    - match: pillar
    - profile.offlinepc
