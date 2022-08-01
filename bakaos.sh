#!/usr/bin/env bash

print_err() { echo -e "\e[1;31mERROR: \e[0;31m$1\e[0m"; }
print_warn() { echo -e "\e[1;33mWARN: \e[0;33m$1\e[0m"; }
print_info() { echo -e "\e[1;37mINFO: \e[0;37m$1\e[0m"; }

# check if running as root
if [ "$(id -u)" = 0 ]; then
	print_err "This script can't be run by the root user!"
	exit
fi

# check if run on arch linux
if ! grep -q "ID=arch" /etc/os-release; then
	print_err "This script can be run only on Arch Linux!"
	exit
fi

# install yay if it's not already installed
if ! command -v yay &> /dev/null; then
	print_info "Yay isn't installed, installing now."
	sleep 1

	print_info "Installing required packages for yay."
	sleep 1

	sudo pacman --needed --ask 4 -Sy git base-devel

	git clone https://aur.archlinux.org/yay.git
	pushd yay

	if ! makepkg -si; then
		print_err "Failed to install yay!"
		popd
		rm -rf yay &> /dev/null
		exit
	else
		print_info "Successfully installed yay"
		sleep 1
	fi

	popd
	rm -rf yay &> /dev/null
fi

print_info "$(yay --version)"
print_info "Installing required packages"

sleep 1

# install required packages
yay pacman --needed --ask 5 -Sy - < "./packages.txt" || print_err "Failed to install required packages."

print_info "Installing rxn's dotfiles..."
sleep 1

pushd ~
git clone https://github.com/rxtthin/dotfiles
pushd dotfiles
stow *
popd

print_info "Successfully installed rxn's dotfiles"
