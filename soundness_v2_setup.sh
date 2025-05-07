# Install necessary dependencies and packages
pkg update -y && pkg upgrade -y && pkg install -y git wget curl proot-distro

# Install Ubuntu in Termux
proot-distro install ubuntu && proot-distro login ubuntu

# Inside the Ubuntu environment, update and install required tools
apt update && apt upgrade -y && apt install -y build-essential protobuf-compiler curl wget pkg-config libcrypto++-dev libc6-dev openssl libssl-dev

# Install Soundness and Rust
curl -sSL https://raw.githubusercontent.com/soundnesslabs/soundness-layer/main/soundnessup/install | bash && \
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs/ | sh -s -- -y && \
source $HOME/.cargo/env && \
soundnessup install && \
soundnessup update

# Generate key
soundness-cli generate-key --name my-key

# Export private key
soundness-cli export-key --name my-key
