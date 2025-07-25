#!/bin/bash

clear
echo "╔════════════════════════════════════════════════════════════╗"
echo "║     🚀 Soundness Node Key Setup Script by @admirkhen       ║"
echo "║    Automates installation, keygen & optional file hosting  ║"
echo "╚════════════════════════════════════════════════════════════╝"
sleep 1

echo "🔧 Updating Ubuntu and installing dependencies..."
apt update && apt upgrade -y && apt install -y build-essential protobuf-compiler curl wget pkg-config libcrypto++-dev libc6-dev openssl libssl-dev python3

echo "🦀 Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

echo "📥 Installing Soundness CLI..."
curl -sSL https://raw.githubusercontent.com/soundnesslabs/soundness-layer/main/soundnessup/install | bash
export PATH="$HOME/.soundnessup/bin:$PATH"
source ~/.bashrc || true

echo "🛠️ Running soundnessup install & update..."
soundnessup install && soundnessup update

# Ask for key name
echo ""
read -p "📌 Enter a name for your key [default: my-key]: " KEY_NAME
KEY_NAME=${KEY_NAME:-my-key}

# Generate the key
echo "🔐 Generating key with name: $KEY_NAME"
soundness-cli generate-key --name "$KEY_NAME"

# Prompt to host localhost
echo ""
read -p "📦 Do you want to host this folder on http://localhost:8080 to download your key_store.json? [y/N]: " HOST_CHOICE

if [[ "$HOST_CHOICE" == "y" || "$HOST_CHOICE" == "Y" ]]; then
    echo "🌐 Hosting current directory on http://localhost:8080"
    echo "📥 Open browser and go to http://localhost:8080/key_store.json to download"
    echo "✅ Press CTRL+C when done to stop hosting."
    python3 -m http.server 8080
else
    echo "✅ Skipped hosting. Your key is saved locally."
fi

echo ""
echo "🎉 Setup completed!"
echo "🔑 To export your private key later: soundness-cli export-key --name $KEY_NAME"
echo "🛡️ Remember to backup your 24-word seed phrase and key_store.json safely."
echo "✨ Script by @admirkhen - https://twitter.com/admirkhen"
