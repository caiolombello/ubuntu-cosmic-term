# 🚀 COSMIC Terminal no Ubuntu - Comece Aqui!

## ✅ SIM, funciona no Ubuntu com GNOME!

O COSMIC Terminal **NÃO** precisa do ambiente desktop COSMIC completo. Ele roda perfeitamente no GNOME, KDE, XFCE ou qualquer outro ambiente desktop do Ubuntu.

---

## 🎯 Instalação Rápida (Recomendado)

Execute o script de instalação automática:

```bash
bash instalar.sh
```

O script irá:
1. ✓ Verificar dependências
2. ✓ Instalar pacotes faltantes (com sua permissão)
3. ✓ Verificar o Rust
4. ✓ Compilar o COSMIC Terminal
5. ✓ Instalar no sistema

**Tempo estimado:** 5-10 minutos (primeira compilação)

---

## 🔧 Instalação Manual

Se preferir fazer manualmente, siga os passos:

### Passo 1: Instalar dependências

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

### Passo 2: Verificar Rust (versão >= 1.85)

```bash
rustc --version
```

Se não tiver Rust instalado ou a versão for muito antiga:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
rustup update stable
```

### Passo 3: Compilar

```bash
cargo clean
cargo build --release
```

### Passo 4: Instalar

```bash
sudo cp target/release/cosmic-term /usr/local/bin/
sudo cp res/com.system76.CosmicTerm.desktop /usr/share/applications/
```

### Passo 5: Executar

```bash
cosmic-term
```

---

## ⚠️ Problemas Comuns

### Erro: "pkg-config não encontrado"

Você não instalou as dependências. Execute:

```bash
sudo apt install pkg-config libxkbcommon-dev libwayland-dev libdbus-1-dev libssl-dev libudev-dev
```

### Erro: "rustc: unknown proxy name: Cursor"

Há um conflito com o rustup. Use o cargo direto da toolchain:

```bash
~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/cargo build --release
```

Ou execute o script `instalar.sh` que já trata isso automaticamente.

### Erro: "incompatible version of rustc"

Limpe os artefatos antigos e recompile:

```bash
cargo clean
cargo build --release
```

### Terminal não aparece no menu

Atualize o cache de aplicativos:

```bash
sudo update-desktop-database
```

---

## 🎨 Recursos do COSMIC Terminal

- ✅ **Renderização GPU** (wgpu) com fallback para CPU
- ✅ **Suporte a ligatures** (para fontes de programação)
- ✅ **Texto bidirecional** (árabe, hebraico, etc.)
- ✅ **Esquemas de cores personalizados**
- ✅ **Performance otimizada**
- ✅ **Funciona em Wayland e X11**

---

## 📖 Documentação Completa

Para mais detalhes, consulte: [INSTALACAO_UBUNTU.md](INSTALACAO_UBUNTU.md)

---

## 🆘 Ajuda

Execute com logs de debug para diagnosticar problemas:

```bash
RUST_LOG=cosmic_term=debug RUST_BACKTRACE=full cosmic-term
```

---

## 🗑️ Desinstalar

```bash
sudo rm /usr/local/bin/cosmic-term
sudo rm /usr/share/applications/com.system76.CosmicTerm.desktop
sudo rm /usr/share/metainfo/com.system76.CosmicTerm.metainfo.xml
```

---

**Resumo:** Sim, você pode usar o COSMIC Terminal no Ubuntu! É só instalar as dependências, compilar e pronto. 🎉

