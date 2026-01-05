#!/bin/bash
# Instalação rápida - o binário já está compilado!

set -e

VERDE='\033[0;32m'
AZUL='\033[0;34m'
NC='\033[0m'

echo -e "${AZUL}=========================================${NC}"
echo -e "${AZUL}  INSTALAÇÃO RÁPIDA - COSMIC TERMINAL${NC}"
echo -e "${AZUL}  (binário já compilado)${NC}"
echo -e "${AZUL}=========================================${NC}"
echo ""

# Verificar se o binário existe
if [ ! -f "target/release/cosmic-term" ]; then
    echo "Erro: Binário não encontrado. Execute 'bash instalar.sh' primeiro."
    exit 1
fi

echo "Digite sua senha para instalar o COSMIC Terminal..."
echo ""

# Instalar binário
sudo install -Dm0755 target/release/cosmic-term /usr/local/bin/cosmic-term

# Instalar ícone personalizado do COSMIC
if [ -f "cosmic-term-icon.svg" ]; then
    sudo install -Dm0644 cosmic-term-icon.svg /usr/share/icons/hicolor/scalable/apps/cosmic-term.svg
fi

# Instalar arquivo desktop personalizado
if [ -f "cosmic-term-custom.desktop" ]; then
    sudo install -Dm0644 cosmic-term-custom.desktop /usr/share/applications/cosmic-term.desktop
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

# Atualizar cache de aplicativos e ícones
sudo update-desktop-database 2>/dev/null || true
sudo gtk-update-icon-cache /usr/share/icons/hicolor/ 2>/dev/null || true

echo ""
echo -e "${VERDE}=========================================${NC}"
echo -e "${VERDE}  ✓ INSTALAÇÃO CONCLUÍDA!${NC}"
echo -e "${VERDE}=========================================${NC}"
echo ""
echo "Execute com:"
echo -e "  ${AZUL}cosmic-term${NC}"
echo ""
echo "Ou procure por 'COSMIC Term' no menu de aplicativos"
echo ""


