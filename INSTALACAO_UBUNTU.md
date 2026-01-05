# 🚀 Guia de Instalação do COSMIC Terminal no Ubuntu

## ✅ Sim, é possível!

O COSMIC Terminal **pode ser instalado e usado no Ubuntu com GNOME** sem problemas. Ele não requer o ambiente desktop COSMIC completo.

## 📦 Pré-requisitos

### 1. Corrigir o problema do Rust

Primeiro, você precisa corrigir o problema do rustup que está acontecendo:

```bash
# Remova o link simbólico problemático do Cursor
rm ~/.cargo/bin/rustup

# Reinstale o rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable -y

# Recarregue o ambiente
source ~/.cargo/env
```

### 2. Verificar a versão do Rust (deve ser >= 1.85)

```bash
rustc --version
cargo --version
```

Se a versão for menor que 1.85:

```bash
rustup update stable
rustup default stable
```

### 3. Instalar dependências do Ubuntu

**IMPORTANTE:** Você precisa instalar estas dependências antes de compilar:

```bash
sudo apt update
sudo apt install -y \
    build-essential \
    pkg-config \
    libfontconfig1-dev \
    libfreetype-dev \
    libxcb1-dev \
    libxcb-render0-dev \
    libxcb-shape0-dev \
    libxcb-xfixes0-dev \
    libxkbcommon-dev \
    libwayland-dev \
    libssl-dev \
    libudev-dev \
    libdbus-1-dev
```

**Faltam no seu sistema:**
- `pkg-config` (OBRIGATÓRIO)
- `libxkbcommon-dev` (OBRIGATÓRIO)
- `libdbus-1-dev` (OBRIGATÓRIO)
- `libssl-dev` (OBRIGATÓRIO)
- `libudev-dev` (OBRIGATÓRIO)

**Nota:** O `just` é um comando similar ao `make`. Se não estiver disponível nos repositórios:

```bash
cargo install just
```

## 🔨 Compilação

No diretório do cosmic-term:

```bash
cd /home/caio/Downloads/cosmic-term

# Compilar em modo release
just build-release

# OU usando cargo diretamente:
cargo build --release
```

A compilação pode demorar alguns minutos na primeira vez (baixa e compila todas as dependências).

## 📥 Instalação

Após a compilação bem-sucedida:

```bash
# Instalar no sistema (requer sudo)
sudo just install

# OU instalar manualmente:
sudo cp target/release/cosmic-term /usr/local/bin/
sudo cp res/com.system76.CosmicTerm.desktop /usr/share/applications/
sudo cp res/com.system76.CosmicTerm.metainfo.xml /usr/share/metainfo/
```

## 🎯 Executar

Após a instalação:

```bash
# Via linha de comando
cosmic-term

# OU procure por "COSMIC Term" no menu de aplicativos do GNOME
```

## 🧪 Testar sem instalar

Se quiser apenas testar antes de instalar:

```bash
./target/release/cosmic-term
```

## ⚠️ Possíveis Problemas

### Problema 1: Versão do Rust muito antiga

```bash
rustup update stable
```

### Problema 2: Faltam dependências Wayland

O COSMIC Terminal funciona melhor no Wayland. Para verificar se está usando Wayland:

```bash
echo $XDG_SESSION_TYPE
```

Se retornar "x11", você pode:
- Continuar usando no X11 (funciona, mas pode ter pequenos problemas)
- Mudar para Wayland (logout → selecionar "Ubuntu on Wayland" na tela de login)

### Problema 3: Erro de compilação

Se houver erros de compilação, tente:

```bash
cargo clean
cargo build --release
```

## 🎨 Recursos

- ✅ Renderização bidirecional
- ✅ Suporte a ligatures
- ✅ Renderização GPU (wgpu) com fallback para CPU (softbuffer)
- ✅ Esquemas de cores personalizados
- ✅ Totalmente funcional no GNOME/Wayland
- ✅ Também funciona no X11

## 📝 Desinstalar

```bash
sudo just uninstall

# OU manualmente:
sudo rm /usr/local/bin/cosmic-term
sudo rm /usr/share/applications/com.system76.CosmicTerm.desktop
sudo rm /usr/share/metainfo/com.system76.CosmicTerm.metainfo.xml
```

## 🆘 Ajuda

Se encontrar problemas, você pode executar com logs de debug:

```bash
RUST_LOG=cosmic_term=debug RUST_BACKTRACE=full ./target/release/cosmic-term
```

---

**Resumo:** Sim, você pode usar o COSMIC Terminal no Ubuntu! Ele é independente do ambiente desktop COSMIC e funciona perfeitamente no GNOME. 🎉

