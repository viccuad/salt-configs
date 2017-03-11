themes_recurse_files:
  file.recurse:
    - name: /usr/share/themes/
    - source: salt://{{ slspath }}/templates/
    - file_mode: 755
    - dir_mode: 755
    - include_empty: True
    - exclude_pat: .gitignore

themes_install:
  pkg.installed:
    - names:
      - gnome-themes-standard
      - gtk2-engines
      - gtk2-engines-pixbuf
      - gtk2-engines-murrine
      - gtk2-engines-aurora
