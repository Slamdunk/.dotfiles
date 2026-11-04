# Dual boot con Windows

In caso si volesse fare dual boot con Windows, bisogna accertarsi che Windows salvi l’orario interno del PC in formato UTC, altrimenti vanno in conflitto tra loro.

Seguire il paragrafo “Option Two: Make Windows Use UTC Time” nel link:
https://www.howtogeek.com/323390/how-to-fix-windows-and-linux-showing-different-times-when-dual-booting/

# OS di riferimento: Ubuntu 26.04 LTS (compatibile con Debian 13)

## Firewall

Abilitare il firewall, lasciando aperte le porte:

1. 9003: PHPStorm in ascolto per xDebug su Docker e da server di Sviluppo

```console
sudo ufw enable
sudo ufw allow from 172.18.0.0/16 proto tcp to any port 9003
```

## Sysctl

Da Ubuntu 26.04 e Debian 13 il file `/etc/sysctl.conf` non viene più letto: usare un file in `/etc/sysctl.d/`.

```console
printf 'vm.swappiness = 10\nfs.inotify.max_user_watches = 524288\n' | sudo tee /etc/sysctl.d/99-local.conf
sudo sysctl --system
```

## Software di base

Come primo step eseguire i punto `1` e `2` al seguente link:

https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

Poi:

```console
echo '{"default-address-pools": [{"base":"172.18.0.0/16","size":24}]}' | sudo tee /etc/docker/daemon.json
```

```console
sudo apt update \
&& sudo apt install \
    vim vim-gtk3 \
    git \
    curl \
    bash-completion \
    tmux xclip wl-clipboard \
    fzf ripgrep \
    geany geany-plugin-lineoperations geany-plugin-prettyprinter geany-plugin-addons \
    htop iotop \
    make \
    meld \
    ncdu \
    libnss3-tools network-manager-openvpn-gnome \
&& sudo usermod -aG docker $USER
```

Il gruppo `docker` è attivo solo dopo logout e nuovo login.

Infine installare i dotfiles seguendo il [README](README.md).

## LUKS unlocked with TPM

Da Ubuntu 26.04 in poi.

Individuare la partizione cifrata (`FSTYPE` = `crypto_LUKS`) e sostituirla a `/dev/nvme0n1p3`:

```console
lsblk -f
```

```console
sudo apt install clevis clevis-tpm2 clevis-dracut clevis-luks
sudo clevis luks bind -d /dev/nvme0n1p3 tpm2 '{"pcr_bank":"sha256","pcr_ids":"0,1"}'
sudo dracut -f
# sudo systemd-analyze pcrs
```

Su Debian (che usa initramfs-tools invece di dracut) installare `clevis-initramfs` al posto di `clevis-dracut`
ed eseguire `sudo update-initramfs -u` al posto di `sudo dracut -f`.

## Geany settings

Preferenze per Geany:

1. General > Startup > [ ] Load virtual terminal support
