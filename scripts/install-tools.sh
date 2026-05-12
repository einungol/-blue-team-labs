#!/bin/bash
# Blue Team Labs - Tool Installation Script

echo "=== Blue Team Labs: Installing Tools ==="

# Update
echo "[1/6] Updating system..."
sudo apt update && sudo apt upgrade -y

# Core tools
echo "[2/6] Installing core tools..."
sudo apt install -y \
    git \
    wget \
    curl \
    grep \
    awk \
    strings \
    file

# Network tools
echo "[3/6] Installing network tools..."
sudo apt install -y \
    wireshark \
    tshark \
    tcpdump \
    nmap

# Python & forensics
echo "[4/6] Installing Python & forensics tools..."
pip3 install --user volatility3
pip3 install --user pefile
pip3 install --user yara

# Memory forensics
echo "[5/6] Installing memory forensics..."
git clone --depth 1 https://github.com/volatilityfoundation/volatility3.git
cd volatility3
pip3 install -e .
cd ..

# Log analysis
echo "[6/6] Installing log analysis tools..."
pip3 install --user deepbluecli
pip3 install --user jq

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Verify with:"
echo "  vol --version"
echo "  deepblue --help"
echo "  tshark --version"