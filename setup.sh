#!/bin/bash
# ========== OS Check ==========
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo "❌ This script is intended for Linux (WSL/Ubuntu/Debian-based). Exiting."
  exit 1
fi

# Optional: check for Debian/Ubuntu specifically
if ! grep -qi 'ubuntu\|debian' /etc/os-release 2>/dev/null; then
  echo "⚠️ This script is optimized for Debian/Ubuntu-based systems."
  echo "Proceeding anyway... (may not work correctly)"
fi

# Ask for sudo password upfront and keep sudo alive
sudo -v
while true; do sudo -n true; sleep 60; done 2>/dev/null &
sudo_keepalive_pid=$!

# Set timezone
sudo timedatectl set-timezone Asia/Kolkata

# Setup GPG key and source for eza
sudo mkdir -p /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/gierens.gpg ]; then
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
fi

echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list

# Add Fastfetch PPA
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch -y

# Update & upgrade packages
sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get autoclean -y

# Install packages
sudo apt-get install fish fastfetch eza -y
sudo apt-get update -y

# Install Oh My Fish if not already present
if [ ! -d ~/.local/share/omf ]; then
  curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
  fish -c 'echo Fish was installed successfully!'
fi

# Install Starship silently
sudo curl -sS https://starship.rs/install.sh | sh -s -- --yes > /dev/null 2>&1

# Setup fish config for starship
mkdir -p ~/.config/fish
echo "starship init fish | source" >> ~/.config/fish/config.fish

# Ensure fonts folder exists
mkdir -p ~/.local/share/fonts

# Copy fonts (assuming you're in the correct dir with .ttf files)
cp *ttf ~/.local/share/fonts/

# Setup Starship preset
starship preset pastel-powerline -o ~/.config/starship.toml

# Add eza aliases to fish config
echo 'alias ll "eza -l --icons --colour --no-symlinks --no-user --no-permissions"' >> ~/.config/fish/config.fish
echo 'alias lla "eza -l --icons --colour --no-symlinks -a --no-user --no-permissions"' >> ~/.config/fish/config.fish
echo 'alias ls "eza --icons --colour --no-symlinks --no-user --no-permissions"' >> ~/.config/fish/config.fish

# Set fish as default shell
sudo chsh -s $(which fish)

# Disable fish greeting
fish -c 'set -U fish_greeting ""'

# Auto-run fastfetch on shell start
echo "fastfetch" >> ~/.config/fish/config.fish

# Kill sudo keepalive
kill "$sudo_keepalive_pid"

echo "✅ Setup complete!"
