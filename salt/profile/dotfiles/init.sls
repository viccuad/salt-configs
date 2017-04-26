include:
  - profile.dotfiles.zsh
  - profile.dotfiles.emacs
  - profile.dotfiles.tmux
  - profile.dotfiles.vim
  - profile.dotfiles.gnupg
  - profile.dotfiles.git
  - profile.dotfiles.pass
  - profile.dotfiles.weechat
  - profile.dotfiles.beets
  - profile.dotfiles.debuggers
  - profile.dotfiles.lxc
  - profile.dotfiles.vagrant
  - profile.dotfiles.debian
  - profile.dotfiles.nvim
  - profile.dotfiles.signing-party
  - profile.dotfiles.virtualenvwrapper
  - profile.dotfiles.golang
# Don't execute the private state unless the git submodule has been initialized.
# If the submodule is there, that means we can apply the second phase of salt
# states.
# Current solution only works if using salt masterless:
{% if salt['file.directory_exists']('/srv/salt/profile/dotfiles/private/.git') %}
  - profile.dotfiles.private
{% endif %}
