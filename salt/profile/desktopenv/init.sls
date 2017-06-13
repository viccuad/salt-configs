include:
  - profile.desktopenv.fonts
  - profile.desktopenv.icons
  - profile.desktopenv.themes
  - profile.desktopenv.games

desktopenv_install:
  pkg.installed:
    - names:
      - emacs25 # gui
      - gnome
      - fwupd
      - gnome-software-plugin-flatpak
      - firefox-esr
      - xul-ext-ublock-origin
      - xul-ext-https-everywhere
      - xul-ext-itsalltext
      - xul-ext-noscript
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

desktopenv_install_contrib_nonfree:
  pkg.installed:
    - names:
      - unrar
      - intel-microcode
      - iucode-tool

desktopenv_passmenu_keybinding:
  cmd.run:
    - names:
      - gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom20/ binding '<Super>F2'
      - gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom20/ command '.dotfiles/pass/nostow/bin/passmenu --type'
      - gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom20/ name 'Passmenu'
    - require:
      - pkg: dconf-gsettings-backend
