# See https://blogs.gnome.org/thaller/2016/08/26/mac-address-spoofing-in-networkmanager-1-4-0
mac_spoofing_enable:
  file.append:
    - name: /etc/NetworkManager/conf.d/30-mac-randomization.conf
    - makedirs: True
    - text: |
            [device-mac-randomization]
            # "yes" is already the default for scanning
            wifi.scan-rand-mac-address=yes

            [connection-mac-randomization]
            ethernet.cloned-mac-address=random
            wifi.cloned-mac-address=random
