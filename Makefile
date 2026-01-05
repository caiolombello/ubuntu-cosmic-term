.PHONY: install uninstall clean build deps

# Installation paths
PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
APPDIR = /usr/share/applications

# Build configuration
CARGO_FLAGS = --release

# Default target
all: build

# Install system dependencies
deps:
	sudo apt update
	sudo apt install -y build-essential pkg-config libfontconfig1-dev \
		libfreetype6-dev libxcb-xfixes0-dev libxkbcommon-dev

# Build the project
build:
	cargo build $(CARGO_FLAGS)

# Install cosmic-term
install: build
	sudo install -Dm755 target/release/cosmic-term $(BINDIR)/cosmic-term
	sudo install -Dm644 cosmic-term.desktop $(APPDIR)/cosmic-term.desktop
	sudo update-desktop-database
	@echo "cosmic-term installed successfully!"
	@echo "Run 'make set-default' to set as default terminal"

# Set as default terminal
set-default:
	sudo update-alternatives --install /usr/bin/x-terminal-emulator \
		x-terminal-emulator $(BINDIR)/cosmic-term 50
	sudo update-alternatives --config x-terminal-emulator

# Uninstall cosmic-term
uninstall:
	sudo rm -f $(BINDIR)/cosmic-term
	sudo rm -f $(APPDIR)/cosmic-term.desktop
	sudo update-desktop-database
	sudo update-alternatives --remove x-terminal-emulator $(BINDIR)/cosmic-term

# Clean build artifacts
clean:
	cargo clean

# Quick setup (deps + install + set default)
setup: deps install set-default
