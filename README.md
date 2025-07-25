🧠 Install Ubuntu & Get Your Keys (PC & PHONE)

1. 📲 For PHONE users (Termux) (SKIP TO STEP 3 IF USING PC OR VPS):

Update Termux and install Ubuntu:
```
pkg update -y && pkg upgrade -y && pkg install proot-distro git wget -y && proot-distro install ubuntu && proot-distro login ubuntu
```

---

2. 🔑 Log into Ubuntu:
```
proot-distro login ubuntu
```
📹 Confused? Watch this quick video for Ubuntu light installation on phone:[Watch Video](https://x.com/thecryptoBike/status/1948065579191156800?t=CN4uTAoquvLtb3c2l9zANA&s=19)


---

3. 💻 For PC Users (Start Here)

📱 Phone users continue from here after steps 1 & 2.

Update Ubuntu & install dependencies:
```
apt update && apt upgrade -y && apt install -y build-essential protobuf-compiler curl wget pkg-config libcrypto++-dev libc6-dev openssl libssl-dev

```
---

4. 🧪 Install Soundness & Generate Your Key

> (Change my-key to any name you like or leave as is.)


```
curl -sSL https://raw.githubusercontent.com/soundnesslabs/soundness-layer/main/soundnessup/install | bash && \
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs/ | sh -s -- -y && \
source $HOME/.cargo/env && \
export PATH="$HOME/.soundnessup/bin:$PATH" && \
soundnessup install && \
soundnessup update && \
soundness-cli generate-key --name my-key
```

---

5. ♻️ Reload Shell (if things don’t work smoothly):
```
source /root/.bashrc

```
---

6. 📋 Copy your 24-word phrase

Use 1234 as your password when prompted.
```
soundnessup install && soundnessup update
soundness-cli generate-key --name my-key
```

---

✅ Like & follow on X (Twitter) — @admirkhen

