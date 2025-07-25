#!/bin/bash
export LANG=en_US.UTF-8

# 📂 Detect current script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 🎨 Banner
echo -e "╔════════════════════════════════════════════════════════════╗"
echo -e "║     🚀 \e[1mSoundness Node Key Setup Script by @admirkhen\e[0m       ║"
echo -e "║    Automates install, keygen & serves key_store.json file  ║"
echo -e "╚════════════════════════════════════════════════════════════╝"
echo ""

# 🔍 Ask device type
echo -e "📱 Where are you running this script?"
echo -e "1️⃣  Laptop / VPS (with sudo)"
echo -e "2️⃣  Phone / Termux (no sudo)"
read -p "👉 Enter 1 or 2: " device_type

if [ "$device_type" == "1" ]; then
    run_with_sudo=true
elif [ "$device_type" == "2" ]; then
    run_with_sudo=false
else
    echo -e "❌ \e[1mInvalid option.\e[0m Please enter 1 or 2."
    exit 1
fi

# 📦 Install dependencies
echo -e "\n📦 Installing dependencies..."
if $run_with_sudo; then
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y build-essential protobuf-compiler curl wget pkg-config libcrypto++-dev libc6-dev openssl libssl-dev python3
else
    apt update && apt upgrade -y
    apt install -y build-essential protobuf-compiler curl wget pkg-config libcrypto++-dev libc6-dev openssl libssl-dev python3
fi

# 🦀 Install Rust
echo -e "\n🦀 Installing Rust toolchain..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# 📥 Install Soundness CLI
echo -e "\n📥 Installing Soundness CLI..."
curl -sSL https://raw.githubusercontent.com/soundnesslabs/soundness-layer/main/soundnessup/install | bash
export PATH="$HOME/.soundnessup/bin:$PATH"
echo 'export PATH="$HOME/.soundnessup/bin:$PATH"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"

# 🛠️ Install & Update soundness-cli
echo -e "\n🔄 Running: soundnessup install & update..."
soundnessup install && soundnessup update

# 🔐 Generate key
echo ""
read -p "📌 Enter a name for your key [default: my-key]: " KEY_NAME
KEY_NAME=${KEY_NAME:-my-key}
echo -e "\n🔐 Generating key with name: \e[1m$KEY_NAME\e[0m"
cd "$SCRIPT_DIR"
soundness-cli generate-key --name "$KEY_NAME"

# ✅ Look for the key in current directory
KEY_PATH="$SCRIPT_DIR/${KEY_NAME}_key_store.json"
if [ ! -f "$KEY_PATH" ]; then
    echo -e "\n❌ \e[1mERROR:\e[0m key_store.json not found at:"
    echo -e "\e[33m$KEY_PATH\e[0m"
    echo -e "⚠️  Expected it in same folder as script. Check manually."
    exit 1
fi

# 🌍 Host key if desired
echo ""
read -p "🌐 Do you want to serve key_store.json at http://localhost:8080? [y/N]: " HOST_CHOICE

if [[ "$HOST_CHOICE" == "y" || "$HOST_CHOICE" == "Y" ]]; then
    echo -e "\n🌐 Hosting \e[32m$KEY_PATH\e[0m at: http://localhost:8080"
    echo -e "📋 Press CTRL+C after copying the key."
    cd "$SCRIPT_DIR"
    python3 -m http.server 8080
else
    echo -e "\n✅ Key generated at:"
    echo -e "\e[32m$KEY_PATH\e[0m"
fi

echo ""
echo -e "🎉 \e[1mDONE!\e[0m Script by \e[36m@admirkhen\e[0m"
