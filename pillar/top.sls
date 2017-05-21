base:
  '*':
    - common
  'aworkstation':
    - role.dotfiles
  'aserver':
    - role.server
  'anofflinepc':
    - role.offlinepc
  'arouter':
    - role.server
    - role.freedombox
