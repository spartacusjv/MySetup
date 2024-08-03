sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch -y
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install neovim fish fastfetch gpg eza -y
sudo apt update -y
if [ -d ~/.local/share/omf ]; then
  echo "........"
 else
  curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
fi
curl -sS https://starship.rs/install.sh | sh
echo "starship init fish | source" >> ~/.config/fish/config.fish
if [ -d ~/.local/share/fonts ]; then
  echo "........"
 else 
  mkdir -p ~/.local/share/fonts
fi
cp *ttf ~/.local/share/fonts/
fc-cache -f -v 
starship preset pastel-powerline -o ~/.config/starship.toml 
sudo apt update
echo "alias ll "eza -l --icons --colour --no-symlinks --no-user --no-permissions" " >> ~/.config/fish/config.fish
echo "alias lla "eza -l --icons --colour --no-symlinks -a --no-user --no-permissions" " >> ~/.config/fish/config.fish
echo "alias ls "eza --icons --colour --no-symlinks --no-user --no-permissions" " >> ~/.config/fish/config.fish
chsh -s $(which fish)
set -U fish_greeting ""
echo "fastfetch" >> ~/.config/fish/config.fish





