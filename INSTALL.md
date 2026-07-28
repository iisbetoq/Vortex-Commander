# VORTEX Agent Commander — Panduan Install

## 1. Clone repositori

Buka terminal, lalu:

```bash
git clone https://github.com/iisbetoq/Vortex-Commander.git
cd Vortex-Commander
```

> **Catatan:** Kalo belum punya git, install dulu:
> ```bash
> sudo apt install git -y       # Ubuntu/Debian
> sudo dnf install git -y       # Fedora
> ```

## 2. Install Hermes Agent (wajib)

```bash
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
```

Tutup terminal, buka lagi. Terus set model:

```bash
hermes model
```

## 3. Install VORTEX Commander

Jalankan:

```bash
./install/install.sh
```

Nanti ditanya: **VPS** atau **Local**?

| Mode | Buat | Keterangan |
|------|------|------------|
| **Local** | PC/laptop sendiri | Tanpa sudo, venv aja |
| **VPS** | Server online | Pasang systemd, firewall, domain |

**Pilih Local** kalo install di laptop/PC sendiri.

## 4. Jalankan

```bash
./run.sh start
```

Tunggu beberapa detik, buka browser:

```
http://127.0.0.1:61318
```

**Login key** bisa dilihat di:

```bash
grep VORTEX_ADMIN_KEY ~/.hermes/.env
```

## Perintah dasar

```bash
./run.sh start       # Jalankan
./run.sh stop        # Hentikan
./run.sh restart     # Restart
./run.sh status      # Cek status
./run.sh logs        # Lihat log
```

## Backup & pindah mesin

```bash
# Di mesin lama:
./scripts/backup.sh
# Hasil: vortex-commander-backup.tar.gz

# Di mesin baru:
tar xzf vortex-commander-backup.tar.gz
cd commander && ./run.sh start
```

## Ganti brand

```bash
python3 set_brand.py "Nama Agent Kamu"
```
