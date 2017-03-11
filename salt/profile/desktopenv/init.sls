include:
  - profile.desktopenv.fonts
  - profile.desktopenv.icons
desktopenv_install:
  pkg.installed:
    - names:
      - firefox
      - python-neovim-gui
      - firewall-applet
      - calibre
      - ardour
      - chromium
      - drumgizmo
      - dgedit
      - guitarix
      - gparted
      - meld
      - pomodoro
      - tor browser
      - vlc
      - virt-manager
      - tails-installer
      - gnome-extensions
      - vrms
      - pinentry-gnome3
      - yubioath-desktop
  cmd.run:
    - names:
      - yubikey-*

desktopenv_enable_multiarch:
  cmd.run:
    - names:
      - dpkg --add-architecture i386

desktopenv_install_contrib_nonfree:
  pkg.installed:
    - names:
      - steam
      - steam-devices
      - virtualbox
      - virtualbox-dkms
      - virtualbox-qt
      - unrar
      - intel-microcode
      - iucode-tool

desktopenv_passmenu_keybinding:
  cmd.run:
    - names:
      - gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom20/ binding '<Super>F2'
      - gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom20/ command '.dotfiles/pass/nostow/bin/passmenu --type'
      - gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom20/ name 'Passmenu'
  requires:
    pkg.installed:
      - dconf-gsettings-backend
