#!/bin/bash

clear
echo "╔════════════════════════════════════════════════════════════╗"
echo "║     🚀 Soundness Node Key Setup Script by @admirkhen       ║"
echo "║    Automates installation, keygen & displays save notice   ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📱 Where are you running this script?"
echo "1️⃣ Laptop / VPS (with sudo)"
echo "2️⃣ Phone / Termux (without sudo)"
read -p "👉 Enter 1 or 2: " device_type

if [ "$device_type" == "1" ]; then
    run_with_sudo=true
elif [ "$device_type" == "2" ]; then
    run_with_sudo=false
else
    echo "❌ Invalid option. Please enter 1 or 2."
    exit 1
fi

# 📦 Install base dependencies
if $run_with_sudo; then
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y build-essential protobuf-compiler curl wget pkg-config libcrypto++-dev libc6-dev openssl libssl-dev python3
else
    apt update && apt upgrade -y
    apt install -y build-essential protobuf-compiler curl wget pkg-config libcrypto++-dev libc6-dev openssl libssl-dev python3
fi

# 🦀 Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# 📥 Install Soundness CLI
curl -sSL https://raw.githubusercontent.com/soundnesslabs/soundness-layer/main/soundnessup/install | bash

# 🔧 PATH fallback: Ensure soundnessup works regardless of shell
echo 'export PATH="$HOME/.soundnessup/bin:$PATH"' >> ~/.bashrc

# Try 5 common shell config sources to load soundnessup
{
  source ~/.bashrc 2>/dev/null
  source ~/.profile 2>/dev/null
  source ~/.zshrc 2>/dev/null
  source /root/.bashrc 2>/dev/null
  export PATH="$HOME/.soundnessup/bin:$PATH"
} || true

# ✅ Final fallback echo (ensures future sessions recognize it)
echo 'export PATH="$HOME/.soundnessup/bin:$PATH"' >> ~/.profile

# 🔄 Install & update
soundnessup install && soundnessup update

# 🔐 Key generation
echo ""
read -p "📌 Enter a name for your key [default: my-key]: " KEY_NAME
KEY_NAME=${KEY_NAME:-my-key}
echo "🔐 Generating key with name: $KEY_NAME"
soundness-cli generate-key --name "$KEY_NAME"

# 🎉 Done
echo ""
echo "✅ Key generated and automatically saved as: key_store.json"
echo "🛡️ Backup your key_store.json file and 24-word seed phrase securely."
echo ""
echo "🔑 To export later: soundness-cli export-key --name $KEY_NAME"
echo "✨ Script by @admirkhen — https://twitter.com/admirkhen"
