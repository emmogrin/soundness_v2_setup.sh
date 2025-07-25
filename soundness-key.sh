#!/bin/bash

# 🎨 Banner
echo "╔════════════════════════════════════════════════════════════╗"
echo "║     🚀 Soundness Node Key Setup Script by @admirkhen       ║"
echo "║    Automates installation, keygen & optional file viewing  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# 🔍 Ask device type
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
source "$HOME/.cargo/env"

# 📥 Install Soundness CLI
curl -sSL https://raw.githubusercontent.com/soundnesslabs/soundness-layer/main/soundnessup/install | bash

# ➕ Add soundnessup to PATH
export PATH="$HOME/.soundnessup/bin:$PATH"
echo 'export PATH="$HOME/.soundnessup/bin:$PATH"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"

# 🛠️ Install & Update soundness-cli
soundnessup install && soundnessup update

# 🧪 Validate CLI install
if ! command -v soundness-cli >/dev/null; then
    echo "❌ soundness-cli still not found after install. Check PATH and try again."
    exit 1
fi

# 🔐 Generate key
echo ""
read -p "📌 Enter a name for your key [default: my-key]: " KEY_NAME
KEY_NAME=${KEY_NAME:-my-key}
echo "🔐 Generating key with name: $KEY_NAME"
soundness-cli generate-key --name "$KEY_NAME"

# 📂 Look for generated key path
KEY_PATH="$HOME/.soundness/keys/$KEY_NAME/key_store.json"

if [ ! -f "$KEY_PATH" ]; then
    echo "❌ Error: key_store.json not found at expected location: $KEY_PATH"
    exit 1
fi

# 🌍 Ask to host
echo ""
read -p "🌐 Do you want to view key_store.json at http://localhost:8080? [y/N]: " HOST_CHOICE

if [[ "$HOST_CHOICE" == "y" || "$HOST_CHOICE" == "Y" ]]; then
    echo "🌐 Hosting key_store.json at: http://localhost:8080/key_store.json"
    echo "📋 You can open it in a browser or curl to copy it safely."
    echo "✅ Press CTRL+C after copying."
    cd "$(dirname "$KEY_PATH")"
    python3 -m http.server 8080
else
    echo "✅ Skipped hosting. Your key is saved here:"
    echo "$KEY_PATH"
fi

echo ""
echo "🎉 Setup completed!"
echo "🔑 To export private key (coming soon): soundness-cli export-key --name $KEY_NAME"
echo "🛡️ Backup your 24-word seed phrase and key_store.json safely."
echo "✨ Script by @admirkhen - https://twitter.com/admirkhen"
