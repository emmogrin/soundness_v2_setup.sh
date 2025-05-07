## Install Ubuntu

1. First, update Termux and install Ubuntu:

```bash
pkg update -y && pkg upgrade -y && pkg install proot-distro git wget -y && proot-distro install ubuntu && proot-distro login ubuntu
