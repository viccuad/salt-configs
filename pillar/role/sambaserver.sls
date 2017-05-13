# https://wiki.debian.org/SambaServerSimple
# https://wiki.debian.org/SAMBAClientSetup

samba_sections:
  global:
    workgroup: VICGROUP
    server string: "Samba Server"
    # printcap name: /etc/printcap
    load printers: yes
    log file: "/var/log/samba/%m.log"
    max log size: 50
    security: user
    dns proxy: no
  homes:
    comment: "Home Directories"
    browseable: no
    writeable: yes
  printers:
    comment: "All Printers"
    path: /var/spool/samba
    browseable: no
    guest ok: no
    writeable: no
    printable: yes
  # sharename:
  #   comment: "This is a shared directory"
  #   browseable: yes
  #   writeable: yes
  #   valid users: @sharegroup
  #   force group: sharegroup
  #   create mask: '0660'
  #   directory mask: '2770'
  vicshare:
    comment: "vic samba share"
    path: /srv/media/vic
    valid users: vic
    create mode: '0660'
    directory mode: '0770'
    public: no
    writable: yes
    printable: no

samba_users:
  vic:
    password: linux
  # user2:
  #   password: user2sambapassword
