# Dual boot with Windows

When dual booting with Windows, make sure Windows stores the PC's hardware clock in UTC, otherwise the two systems conflict with each other.

Follow the "Option Two: Make Windows Use UTC Time" section at:
https://www.howtogeek.com/323390/how-to-fix-windows-and-linux-showing-different-times-when-dual-booting/

# Reference OS: Ubuntu 26.04 LTS (compatible with Debian 13)

## Firewall

Enable the firewall, leaving these ports open:

1. 9003: PHPStorm listening for Xdebug from Docker and from development servers

```console
sudo ufw enable
sudo ufw allow from 172.18.0.0/16 proto tcp to any port 9003
```

## Sysctl

Since Ubuntu 26.04 and Debian 13 the `/etc/sysctl.conf` file is no longer read: use a file in `/etc/sysctl.d/`.

```console
printf 'vm.swappiness = 10\nfs.inotify.max_user_watches = 524288\n' | sudo tee /etc/sysctl.d/99-local.conf
sudo sysctl --system
```

## Base software

As a first step, follow steps `1` and `2` at:

https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

Then:

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

The `docker` group membership takes effect only after logging out and back in.

Finally, install the dotfiles following the [README](README.md).

## LUKS unlocked with TPM

From Ubuntu 26.04 onwards.

Find the encrypted partition (`FSTYPE` = `crypto_LUKS`) and use it in place of `/dev/nvme0n1p3`:

```console
lsblk -f
```

```console
sudo apt install clevis clevis-tpm2 clevis-dracut clevis-luks
sudo clevis luks bind -d /dev/nvme0n1p3 tpm2 '{"pcr_bank":"sha256","pcr_ids":"0,1"}'
sudo dracut -f
# sudo systemd-analyze pcrs
```

On Debian (which uses initramfs-tools instead of dracut) install `clevis-initramfs` instead of `clevis-dracut`
and run `sudo update-initramfs -u` instead of `sudo dracut -f`.

## Geany settings

Geany preferences:

1. General > Startup > [ ] Load virtual terminal support
