#!/bin/bash

clear
echo "╔════════════════════════════════════════════════════════════╗"
echo "║     🚀 Soundness Node Key Setup Script by @admirkhen       ║"
echo "║    Automates installation, keygen & optional file viewing  ║"
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
export PATH="$HOME/.soundnessup/bin:$PATH"
source ~/.bashrc || true

# 🛠️ Install and update
soundnessup install && soundnessup update

# 🔐 Key generation
echo ""
read -p "📌 Enter a name for your key [default: my-key]: " KEY_NAME
KEY_NAME=${KEY_NAME:-my-key}
echo "🔐 Generating key with name: $KEY_NAME"
soundness-cli generate-key --name "$KEY_NAME"

# ✅ Use correct local path (relative to where script is run)
KEY_PATH="./keys/$KEY_NAME/key_store.json"

if [ ! -f "$KEY_PATH" ]; then
    echo "❌ Error: Key file not found at $KEY_PATH"
    exit 1
fi

# 🌍 Ask to host content
echo ""
read -p "🌐 Do you want to view key_store.json at http://localhost:8080? [y/N]: " HOST_CHOICE

if [[ "$HOST_CHOICE" == "y" || "$HOST_CHOICE" == "Y" ]]; then
    cd "$(dirname "$KEY_PATH")"
    echo "🌐 Hosting key_store.json at: http://localhost:8080/$(basename "$KEY_PATH")"
    echo "📋 You can open it in a browser or curl to copy it safely."
    echo "✅ Press CTRL+C after copying."
    python3 -m http.server 8080
else
    echo "✅ Skipped hosting. You can find your key at:"
    echo "$KEY_PATH"
fi

echo ""
echo "🎉 Setup completed!"
echo "🔑 To export private key later: soundness-cli export-key --name $KEY_NAME"
echo "🛡️ Remember to backup your 24-word seed phrase and key_store.json safely."
echo "✨ Script by @admirkhen - https://twitter.com/admirkhen"
