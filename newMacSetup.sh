#!/bin/bash




isBrewInstalled=$(which brew);

if [ -z "$isBrewInstalled"]; then
    echo "brew not installed installing now"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "already installed"
fi


echo "install git"
brew install git

echo "git config"
git config --global user.name "Mikaela Donovan"
git config --global user.email "mikaelasomerville@gmail.com"


echo "install Google Chrome"
brew install --cask google-chrome

echo "install discord"
brew install --cask discord

echo "install rider"
brew install --cask rider

echo "install node"
brew install node

echo "install wget"
brew install wget


echo "install obsidian"
brew install --cask obsidian


echo "install docker"
brew install --cask docker-desktop 


echo "you will need to manually install python 3"
read -p "Press [Enter] key after this..."
