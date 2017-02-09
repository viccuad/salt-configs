include:
  - ssh_keys.users.viccuad

locale:
  present:
    - "en_US.UTF-8"
    - "es_ES.UTF-8"
  default:
    name: 'en_US.UTF-8' # Note: On debian systems don't write the
                        # second 'UTF-8' here or you will experience
                        # salt problems like:
                        # LookupError: unknown encoding: utf_8_utf_8
                        # Restart the minion after you corrected this!
    requires: 'en_US.UTF-8'
  # You can manipulate the contents of /etc/locale.conf, e.g.
  conf:
    - 'LANG=en_US.UTF-8'
    - 'LC_TIME=de_DE.UTF-8'
    - 'LC_PAPER=en_UK.UTF-8'
    - 'LC_MEASUREMENT=es_ES.UTF-8'
