include:
  - profile.desktopenv.fonts
  - profile.desktopenv.icons
  - profile.desktopenv.themes
  - profile.desktopenv.games

desktopenv_install:
  pkg.installed:
    - names:
      - gnome
      - firefox-esr
      - dconf-gsettings-backend
      - firewall-applet
      - calibre
      - ardour
      - chromium
      - drumgizmo
      - dgedit
      - guitarix
      - gparted
      - meld
      - gnome-shell-pomodoro
      - torbrowser-launcher
      - vlc
      - virt-manager
      - gnome-shell-extensions
      - vrms
      - pinentry-gnome3
      - yubioath-desktop
      - yubikey-neo-manager
      - yubikey-personalization
      - yubikey-personalization-gui
      - intel-gpu-tools

desktopenv_enable_multiarch:
  cmd.run:
    - names:
      - dpkg --add-architecture i386
      # needs license approval:
      - apt-get -y install steam

desktopenv_install_contrib_nonfree:
  pkg.installed:
    - names:
      - steam-devices
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
