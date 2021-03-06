states:
  profile.common: true

include:
  - ssh_keys.users.viccuad

timezone:
  name: 'Europe/Berlin'
  utc: True

locale:
  present:
    - "en_US.UTF-8"
    - "en_GB.UTF-8"
    - "es_ES.UTF-8"
    - "en_DK.UTF-8"
  default:
    name: 'en_DK.UTF-8' # Note: On debian systems don't write the
                        # second 'UTF-8' here or you will experience
                        # salt problems like:
                        # LookupError: unknown encoding: utf_8_utf_8
                        # Restart the minion after you corrected this!
    requires: 'en_DK.UTF-8'
  # You can manipulate the contents of /etc/locale.conf, e.g.
  conf:
    - 'LC_NUMERIC=en_DK.UTF-8'
    - 'LC_TIME=en_DK.UTF-8'
    - 'LC_MONETARY=en_DK.UTF-8'
    - 'LC_PAPER=en_DK.UTF-8'
    - 'LC_MEASUREMENT=en_DK.UTF-8'

sshd_config:
  PermitRootLogin: 'no'
  PasswordAuthentication: 'no'
  RSAAuthentication: 'no'
  PubkeyAuthentication: 'yes'
  PermitEmptyPasswords: 'no'
  AcceptEnv: "LANG LC_*"
  Ciphers:
    - 'aes256-ctr'
  MACs:
    - 'hmac-sha2-512'

openssh:
  # Controls if SSHD should be enabled/started
  sshd_enable: true
