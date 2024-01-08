#!/bin/sh

# check folders ownership
for d in /home/venus /opt/workspace
do
  [ $(ls -ld $d | cut -d' ' -f3) = 'venus' ] || sudo chown -R venus:venus $d
done

# .bash_profile
[ -f /home/venus/.bash_profile ] || cat <<'EOL' >> /home/venus/.bashrc
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\[\033[00m\]:\[\033[01;97m\]\w\[\033[00m\]  '
alias ls='ls --color'
EOL

# start jupyterlab
. /opt/venv/bin/activate && jupyter lab --ip=0.0.0.0 --allow-root --no-browser --IdentityProvider.token='' --ServerApp.password='' --ServerApp.terminado_settings='{"shell_command":["/usr/bin/bash"]}' --ServerApp.root_dir='/opt/workspace'

# done
exit 0

# EOF
