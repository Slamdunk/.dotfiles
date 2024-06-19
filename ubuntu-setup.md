# Dual boot con Windows

In caso si volesse fare dual boot con Windows, bisogna accertarsi che Windows salvi l’orario interno del PC in formato UTC, altrimenti vanno in conflitto tra loro.

Seguire il paragrafo “Option Two: Make Windows Use UTC Time” nel link:
https://www.howtogeek.com/323390/how-to-fix-windows-and-linux-showing-different-times-when-dual-booting/

# OS di riferimento: Ubuntu 20.04

## Firewall

Abilitare il firewall, lasciando aperte le porte:

1. 9003: PHPStorm in ascolto per xDebug su Docker e da server di Sviluppo

```console
sudo ufw enable
sudo ufw allow from 172.18.0.0/16 proto tcp to any port 9003
```

## Sysctl

```console
echo "vm.swappiness = 10" | sudo tee --append /etc/sysctl.conf
echo "fs.inotify.max_user_watches = 524288" | sudo tee --append /etc/sysctl.conf
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
    tmux xclip \
    ripgrep \
    geany geany-plugin-lineoperations geany-plugin-prettyprinter geany-plugin-addons \
    htop iotop \
    make \
    meld \
    ncdu \
    libnss3-tools network-manager-openvpn-gnome \
&& sudo usermod -aG docker $USER
```

## LUKS unlocked with TPM

```console
sudo apt install clevis clevis-tpm2 clevis-luks clevis-initramfs initramfs-tools tss2
sudo clevis luks bind -d /dev/nvme0n1p3 tpm2 '{"pcr_bank":"sha256","pcr_ids":"0,1"}'
sudo update-initramfs -u -k all
# sudo systemd-analyze pcrs
```

## Geany settings

Preferenze per Geany:

1. Editor > Caratteristiche > Marcatore di selezione del commento: togliere la tilda ~ e mettere
uno spazio, per compatibilità con i nostri standard e tutti gli altri editor.
2. Editor > Indentazione > Tipo: Spazi
3. File > Salvataggio File > Assicura fine riga consistenti
4. File > Salvataggio File > Elimina spazi e tabulazioni in coda
