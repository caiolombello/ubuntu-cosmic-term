#!/bin/bash
# Define o COSMIC Terminal como terminal padrão no Ubuntu

set -e

VERDE='\033[0;32m'
AZUL='\033[0;34m'
AMARELO='\033[1;33m'
NC='\033[0m'

echo -e "${AZUL}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${AZUL}║  DEFINIR COSMIC TERMINAL COMO PADRÃO                      ║${NC}"
echo -e "${AZUL}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar se o binário existe
if [ ! -f "target/release/cosmic-term" ]; then
    echo "Erro: Binário não encontrado. Execute 'cargo build --release' primeiro."
    exit 1
fi

echo -e "${AZUL}[1/4] Instalando o COSMIC Terminal no sistema...${NC}"
echo "Digite sua senha para continuar:"
sudo install -Dm0755 target/release/cosmic-term /usr/local/bin/cosmic-term

# Instalar ícone personalizado
if [ -f "cosmic-term-icon.svg" ]; then
    sudo install -Dm0644 cosmic-term-icon.svg /usr/share/icons/hicolor/scalable/apps/cosmic-term.svg
    echo "  ✓ Ícone instalado"
fi

# Instalar arquivo desktop personalizado
if [ -f "cosmic-term-custom.desktop" ]; then
    sudo install -Dm0644 cosmic-term-custom.desktop /usr/share/applications/cosmic-term.desktop
    echo "  ✓ Arquivo .desktop instalado"
else
    # Fallback para o arquivo original
    if [ -f "res/com.system76.CosmicTerm.desktop" ]; then
        sudo install -Dm0644 res/com.system76.CosmicTerm.desktop /usr/share/applications/com.system76.CosmicTerm.desktop
    fi
fi

# Instalar metainfo se existir
if [ -f "res/com.system76.CosmicTerm.metainfo.xml" ]; then
    sudo install -Dm0644 res/com.system76.CosmicTerm.metainfo.xml /usr/share/metainfo/com.system76.CosmicTerm.metainfo.xml
fi

echo -e "${VERDE}✓ Instalação concluída${NC}"
echo ""

echo -e "${AZUL}[2/4] Registrando como alternativa do sistema...${NC}"
# Registrar no sistema de alternativas (se não estiver registrado)
if ! sudo update-alternatives --list x-terminal-emulator 2>/dev/null | grep -q cosmic-term; then
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/cosmic-term 100
    echo -e "${VERDE}✓ Registrado no sistema de alternativas${NC}"
else
    echo -e "${AMARELO}⚠ Já estava registrado${NC}"
fi
echo ""

echo -e "${AZUL}[3/4] Definindo como terminal padrão do sistema...${NC}"
sudo update-alternatives --set x-terminal-emulator /usr/local/bin/cosmic-term
echo -e "${VERDE}✓ Definido como padrão do sistema${NC}"
echo ""

echo -e "${AZUL}[4/4] Configurando para o GNOME...${NC}"
# Definir para GNOME (se estiver usando GNOME)
if [ "$XDG_CURRENT_DESKTOP" = "ubuntu:GNOME" ] || [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
    gsettings set org.gnome.desktop.default-applications.terminal exec 'cosmic-term' 2>/dev/null || true
    gsettings set org.gnome.desktop.default-applications.terminal exec-arg '' 2>/dev/null || true
    echo -e "${VERDE}✓ Configurado para GNOME${NC}"
else
    echo -e "${AMARELO}⚠ Não está usando GNOME, pulando configuração específica${NC}"
fi

# Atualizar cache de aplicativos e ícones
sudo update-desktop-database 2>/dev/null || true
sudo gtk-update-icon-cache /usr/share/icons/hicolor/ 2>/dev/null || true

echo ""
echo -e "${VERDE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${VERDE}║  ✓ COSMIC TERMINAL AGORA É SEU TERMINAL PADRÃO!          ║${NC}"
echo -e "${VERDE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Agora quando você abrir um terminal (Ctrl+Alt+T), o COSMIC Terminal será aberto!"
echo ""
echo -e "${AZUL}Teste agora:${NC}"
echo "  • Pressione Ctrl+Alt+T"
echo "  • Ou clique com botão direito no desktop → 'Abrir Terminal'"
echo "  • Ou execute: ${AZUL}x-terminal-emulator${NC}"
echo ""
echo -e "${AMARELO}Dica:${NC} Para voltar ao terminal anterior, execute:"
echo "  sudo update-alternatives --config x-terminal-emulator"
echo ""

