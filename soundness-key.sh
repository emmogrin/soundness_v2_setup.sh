#!/bin/bash

clear
echo "╔════════════════════════════════════════════════════════════╗"
echo "║     🚀 Soundness Node Key Setup Script by @admirkhen       ║"
echo "║    Automates installation, keygen & optional file hosting  ║"
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

# ✅ Confirm key path
KEY_PATH="$HOME/.soundness/keys/$KEY_NAME/key_store.json"
if [ ! -f "$KEY_PATH" ]; then
    echo "❌ Error: Key file not found at $KEY_PATH"
    exit 1
fi

# 🌍 Ask to serve key for download
echo ""
read -p "📦 Do you want to download key_store.json from http://localhost:8080? [y/N]: " HOST_CHOICE

if [[ "$HOST_CHOICE" == "y" || "$HOST_CHOICE" == "Y" ]]; then
    echo "🌐 Hosting key for download at http://localhost:8080/key_store.json"
    echo "📥 Open this in your browser and it will force download"
    echo "✅ Press CTRL+C after saving the file."

    python3 - <<EOF
import http.server
import socketserver

PORT = 8080
KEY_FILE = "$KEY_PATH"

class ForcedDownloadHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/key_store.json":
            self.send_response(200)
            self.send_header("Content-Type", "application/octet-stream")
            self.send_header("Content-Disposition", "attachment; filename=key_store.json")
            self.end_headers()
            with open(KEY_FILE, "rb") as f:
                self.wfile.write(f.read())
        else:
            self.send_response(404)
            self.end_headers()

with socketserver.TCPServer(("", PORT), ForcedDownloadHandler) as httpd:
    print(f"🔒 Serving on port {PORT}...")
    httpd.serve_forever()
EOF

else
    echo "✅ Skipped hosting. Your key is saved at:"
    echo "$KEY_PATH"
fi

# ✅ Done
echo ""
echo "🎉 Setup completed!"
echo "🔑 To export your private key later: soundness-cli export-key --name $KEY_NAME"
echo "🛡️ Remember to backup your 24-word seed phrase and key_store.json safely."
echo "✨ Script by @admirkhen - https://twitter.com/admirkhen"
