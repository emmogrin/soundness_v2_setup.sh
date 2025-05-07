## Install Ubuntu

1. First, update Termux and install Ubuntu:

```bash
pkg update -y && pkg upgrade -y && pkg install proot-distro git wget -y && proot-distro install ubuntu && proot-distro login ubuntu
```
2. Log into Ubuntu:

```bash
proot-distro login ubuntu
```

3. Update Ubuntu and install necessary dependencies:
```bash
apt update && apt upgrade -y && apt install -y build-essential protobuf-compiler curl wget pkg-config libcrypto++-dev libc6-dev openssl libssl-dev
```


4. Install Soundness and generate your key:
```bash
curl -sSL https://raw.githubusercontent.com/soundnesslabs/soundness-layer/main/soundnessup/install | bash && \
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs/ | sh -s -- -y && \
source $HOME/.cargo/env && \
export PATH="$HOME/.soundnessup/bin:$PATH" && \
soundnessup install && \
soundnessup update && \
soundness-cli generate-key --name my-key
```
5. Reload shell environment
 ```bash
   source /root/.bashrc
```

6.  Proceed fully and copy 24 phrases. for secret key password enter (1234)
   
   ```bash
soundnessup install && soundnessup update
soundness-cli generate-key --name my-key
```


7. To export your private key:
```bash
soundness-cli export-key --name my-key
```

Like and follow on X @admirkhen.
