#!/bin/bash
export RUSTUP_TOOLCHAIN=stable
# Script de instalação do COSMIC Terminal no Ubuntu
# Execute com: bash instalar.sh

set -e  # Sair em caso de erro

echo "========================================="
echo "  INSTALAÇÃO DO COSMIC TERMINAL"
echo "  Para Ubuntu (GNOME, KDE, etc.)"
echo "========================================="
echo ""

# Cores para output
VERDE='\033[0;32m'
VERMELHO='\033[0;31m'
AMARELO='\033[1;33m'
AZUL='\033[0;34m'
NC='\033[0m' # Sem cor

# Verificar se está no diretório correto
if [ ! -f "Cargo.toml" ]; then
    echo -e "${VERMELHO}Erro: Execute este script no diretório cosmic-term${NC}"
    exit 1
fi

echo -e "${AZUL}[1/5] Verificando dependências do sistema...${NC}"
FALTANTES=""

# Lista de pacotes necessários
PACOTES=(
    "pkg-config"
    "libxkbcommon-dev"
    "libwayland-dev"
    "libdbus-1-dev"
    "libssl-dev"
    "libudev-dev"
    "libfontconfig1-dev"
    "libfreetype-dev"
    "libxcb1-dev"
    "libxcb-render0-dev"
    "libxcb-shape0-dev"
    "libxcb-xfixes0-dev"
    "build-essential"
)

for PKG in "${PACOTES[@]}"; do
    if ! dpkg -l | /usr/bin/grep -q "^ii  ${PKG}"; then
        FALTANTES="${FALTANTES} ${PKG}"
    fi
done

if [ -n "$FALTANTES" ]; then
    echo -e "${AMARELO}Os seguintes pacotes precisam ser instalados:${NC}"
    echo "$FALTANTES"
    echo ""
    echo -e "${AMARELO}Execute o seguinte comando para instalá-los:${NC}"
    echo "sudo apt update && sudo apt install -y${FALTANTES}"
    echo ""
    read -p "Deseja instalar agora? (s/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[SsYy]$ ]]; then
        sudo apt update
        sudo apt install -y ${FALTANTES}
    else
        echo -e "${VERMELHO}Instalação cancelada. Instale as dependências manualmente e execute este script novamente.${NC}"
        exit 1
    fi
fi

echo -e "${VERDE}✓ Todas as dependências do sistema estão instaladas${NC}"
echo ""

echo -e "${AZUL}[2/5] Verificando Rust...${NC}"
if ! command -v cargo &> /dev/null; then
    echo -e "${VERMELHO}Rust não está instalado!${NC}"
    echo "Instale o Rust executando:"
    echo "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    exit 1
fi

# Tentar usar o cargo direto da toolchain para evitar problemas com rustup
CARGO_BIN="cargo"
if [ -f "$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/cargo" ]; then
    CARGO_BIN="$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/cargo"
fi

RUST_VERSION=$($CARGO_BIN --version | awk '{print $2}')
echo -e "${VERDE}✓ Rust ${RUST_VERSION} encontrado${NC}"
echo ""

echo -e "${AZUL}[3/6] Preparando ícone...${NC}"
if [ ! -f "cosmic-term-icon.svg" ]; then
    if command -v curl &> /dev/null; then
        curl -L -o cosmic-term-icon.svg "https://raw.githubusercontent.com/pop-os/cosmic-icons/70b07582e24ec2114672256b9657ca80670bca8a/freedesktop/scalable/apps/utilities-terminal.svg" 2>/dev/null
        echo -e "${VERDE}✓ Ícone baixado${NC}"
    elif command -v wget &> /dev/null; then
        wget -O cosmic-term-icon.svg "https://raw.githubusercontent.com/pop-os/cosmic-icons/70b07582e24ec2114672256b9657ca80670bca8a/freedesktop/scalable/apps/utilities-terminal.svg" 2>/dev/null
        echo -e "${VERDE}✓ Ícone baixado${NC}"
    else
        echo -e "${AMARELO}⚠ curl/wget não encontrados, pulando download do ícone${NC}"
    fi
else
    echo -e "${VERDE}✓ Ícone já existe${NC}"
fi

echo -e "${AZUL}[4/6] Limpando builds anteriores e configurando toolchain...${NC}"
$CARGO_BIN clean

# Criar arquivo rust-toolchain.toml para forçar uso da stable
# Isso evita problemas com a edition 2024 tentando usar nightly
if [ ! -f "rust-toolchain.toml" ]; then
    cat > rust-toolchain.toml << 'EOF'
[toolchain]
channel = "stable"
EOF
    echo "Criado rust-toolchain.toml para garantir compilação estável"
fi

echo -e "${VERDE}✓ Limpeza e configuração concluídas${NC}"
echo ""

echo -e "${AZUL}[5/6] Compilando COSMIC Terminal...${NC}"
echo -e "${AMARELO}Isso pode demorar alguns minutos na primeira vez...${NC}"
echo ""

if $CARGO_BIN build --release; then
    echo ""
    echo -e "${VERDE}✓ Compilação bem-sucedida!${NC}"
else
    echo ""
    echo -e "${VERMELHO}✗ Erro na compilação${NC}"
    exit 1
fi

echo ""
echo -e "${AZUL}[6/6] Instalando no sistema...${NC}"

# Verificar se o binário foi criado
if [ ! -f "target/release/cosmic-term" ]; then
    echo -e "${VERMELHO}Erro: Binário não encontrado em target/release/cosmic-term${NC}"
    exit 1
fi

# Instalar
echo "Digite sua senha para instalar o COSMIC Terminal no sistema..."
sudo install -Dm0755 target/release/cosmic-term /usr/local/bin/cosmic-term

# Instalar ícone
if [ -f "cosmic-term-icon.svg" ]; then
    sudo install -Dm0644 cosmic-term-icon.svg /usr/share/icons/hicolor/scalable/apps/com.system76.CosmicTerm.svg
fi

# Instalar arquivo desktop
if [ -f "res/com.system76.CosmicTerm.desktop" ]; then
    sudo install -Dm0644 res/com.system76.CosmicTerm.desktop /usr/share/applications/com.system76.CosmicTerm.desktop
fi

# Instalar metainfo se existir
if [ -f "res/com.system76.CosmicTerm.metainfo.xml" ]; then
    sudo install -Dm0644 res/com.system76.CosmicTerm.metainfo.xml /usr/share/metainfo/com.system76.CosmicTerm.metainfo.xml
fi

# Atualizar caches
sudo update-desktop-database 2>/dev/null || true
sudo gtk-update-icon-cache /usr/share/icons/hicolor/ 2>/dev/null || true

echo ""
echo -e "${VERDE}=========================================${NC}"
echo -e "${VERDE}  ✓ INSTALAÇÃO CONCLUÍDA COM SUCESSO!${NC}"
echo -e "${VERDE}=========================================${NC}"
echo ""
echo "Você pode executar o GNOME Terminal de 3 formas:"
echo ""
echo "  1. Digite no terminal: ${AZUL}gnome-term${NC}"
echo "  2. Procure por 'GNOME Term' no menu de aplicativos"
echo "  3. Execute diretamente: ${AZUL}./target/release/gnome-term${NC}"
echo ""
echo -e "${AMARELO}Dica:${NC} Para desinstalar, execute:"
echo "  sudo rm /usr/local/bin/gnome-term"
echo "  sudo rm /usr/share/applications/com.system76.CosmicTerm.desktop"
echo ""
