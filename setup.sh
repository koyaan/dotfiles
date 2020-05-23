#!/bin/bash

set -euo pipefail

## vmware mount

cat <<EOF | sudo tee /usr/local/sbin/mount-shared-folders
#!/bin/sh
vmware-hgfsclient | while read folder; do
  vmwpath="/mnt/hgfs/\${folder}"
  echo "[i] Mounting \${folder}   (\${vmwpath})"
  sudo mkdir -p "\${vmwpath}"
  sudo umount -f "\${vmwpath}" 2>/dev/null
  sudo vmhgfs-fuse -o allow_other -o auto_unmount ".host:/\${folder}" "\${vmwpath}"
done
sleep 2s
EOF
sudo chmod +x /usr/local/sbin/mount-shared-folders

sudo apt install -y git vim
git clone https://github.com/radareorg/radare2
radare2/sys/install.sh

cat > ~/.radare2rc <<- EOM
e scr.utf8=true
e scr.utf8.curvy=true
e asm.trace=true
e dbg.trace=true
e dbg.verbose=false
e asm.demangle=false
e bin.demangle=false
e scr.color=2
eco monokai
e cfg.fortunes=false
EOM

sudo apt install -y python3-pip
python3 -m pip install virtualenvwrapper
cat >> $HOME/.bashrc <<- EOM
export PATH=\$HOME/.local/bin:\$PATH
export WORKON_HOME=\$HOME/.virtualenvs
VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source \$HOME/.local/bin/virtualenvwrapper.sh
EOM
source $HOME/.bashrc
echo "workon pwn" >> $HOME/.bashrc
mkdir ~/.virtualenvs
sudo apt -y install python3-dev libssl-dev libffi-dev build-essential
mkvirtualenv pwn -p python3
pip install --upgrade git+https://github.com/Gallopsled/pwntools.git@dev
pip install monkeyhex ipython hexdump colorama r2pipe
