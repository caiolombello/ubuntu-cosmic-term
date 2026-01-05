# Installation Guide for Ubuntu

## Prerequisites

Install required dependencies:

```bash
sudo apt update
sudo apt install build-essential pkg-config libfontconfig1-dev libfreetype6-dev libxcb-xfixes0-dev libxkbcommon-dev
```

## Installation

### Option 1: Using Makefile (Recommended)

```bash
make install
```

### Option 2: Manual Installation

1. Build the project:
```bash
cargo build --release
```

2. Install the binary:
```bash
sudo cp target/release/cosmic-term /usr/local/bin/
```

3. Install desktop entry:
```bash
sudo cp cosmic-term.desktop /usr/share/applications/
sudo update-desktop-database
```

## Set as Default Terminal

### Method 1: Using update-alternatives (System-wide)

```bash
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/cosmic-term 50
sudo update-alternatives --config x-terminal-emulator
```

Select cosmic-term from the list.

### Method 2: Using gsettings (GNOME)

```bash
gsettings set org.gnome.desktop.default-applications.terminal exec 'cosmic-term'
```

### Method 3: Desktop Environment Settings

- Open **Settings** → **Default Applications**
- Set **Terminal** to **cosmic-term**

## Verification

Test the installation:
```bash
cosmic-term --version
```

Open a new terminal with Ctrl+Alt+T to verify it's set as default.
