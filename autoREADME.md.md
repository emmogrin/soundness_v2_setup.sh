# 🧪 Soundness Setup Scripts (v2)

Welcome to the ultimate helper scripts for setting up and using the Soundness CLI with zero-knowledge proving support.

This repo contains:

- 🔐 `soundness-key.sh` — Generate and export your key pairs
- 📨 `soundness-proof.sh` — (Coming soon) Submit ZK proofs using files or Walrus Blob IDs

---

## 📦 Features

- Install Soundness CLI & dependencies (Rust, cargo, build tools)
- Generate key pairs with a name of your choice
- Optional localhost file sharing (e.g. to download your `key_store.json`)
- Safety-focused prompts for backups
- Clean terminal prompts for beginners

---

## 🛠️ How to Use

### 1. Clone this repository:
```bash
git clone https://github.com/emmogrin/soundness_v2_setup.sh.git
cd soundness_v2_setup.sh
chmod +x soundness-key.sh
./soundness-key.sh
```

⚠️ Warnings

Always back up key_store.json and your recovery phrase!

Never share your private key or mnemonic.

Scripts are beginner-friendly but assume basic Linux usage.



---

👤 Maintainer

Script by @admirkhen
GitHub: github.com/emmogrin
