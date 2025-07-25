#!/bin/bash

# 📂 Detect current directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 🎨 Banner
echo "╔════════════════════════════════════════════════════════════╗"
echo "║     🚀 Soundness Key Setup Script by @admirkhen            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# 🧩 Ask device type
echo "📱 Where are you running this?"
echo "1️⃣ Laptop / VPS"
echo "2️⃣ Phone / Termux"
read -p "👉 Enter 1 or 2: " device

if [ "$device" = "1" ]; then
    sudo apt update && sudo apt install -y curl build-essential protobuf-compiler pkg-config openssl libssl-dev python3
else
    apt update && apt install -y curl build-essential protobuf-compiler pkg-config openssl libssl-dev python3
fi

# 🦀 Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# 📥 Install soundnessup
curl -sSL https://raw.githubusercontent.com/soundnesslabs/soundness-layer/main/soundnessup/install | bash
export PATH="$HOME/.soundnessup/bin:$PATH"
echo 'export PATH="$HOME/.soundnessup/bin:$PATH"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"

# 🛠 Install CLI
soundnessup install && soundnessup update

# 🔐 Generate key
cd "$SCRIPT_DIR"
read -p "🔑 Key name (for record only, not used in filename): " KEY_NAME
echo "📦 Generating key_store.json..."
soundness-cli generate-key

# ✅ Confirm it exists
if [ ! -f "$SCRIPT_DIR/key_store.json" ]; then
    echo "❌ ERROR: key_store.json not found in $SCRIPT_DIR"
    exit 1
fi

# 🌐 Serve?
read -p "🌍 Host key_store.json on http://localhost:8080? (y/n): " serve
if [[ "$serve" =~ ^[Yy]$ ]]; then
    cd "$SCRIPT_DIR"
    echo "🛰️ Serving key_store.json..."
    python3 -m http.server 8080
else
    echo "✅ Key generated at: $SCRIPT_DIR/key_store.json"
fi

echo ""
echo "🎉 Done. Script by @admirkhen"
