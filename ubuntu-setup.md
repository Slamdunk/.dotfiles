# Dual boot con Windows

In caso si volesse fare dual boot con Windows, bisogna accertarsi che Windows salvi l’orario interno del PC in formato UTC, altrimenti vanno in conflitto tra loro.

Seguire il paragrafo “Option Two: Make Windows Use UTC Time” nel link:
https://www.howtogeek.com/323390/how-to-fix-windows-and-linux-showing-different-times-when-dual-booting/

# OS di riferimento: Ubuntu 20.04

## Firewall

Abilitare il firewall, lasciando aperte le porte:

1. 9003: PHPStorm in ascolto per xDebug su Docker e da server di Sviluppo

```
sudo ufw enable
sudo ufw allow 9003/tcp
```

## Sysctl

```
echo "vm.swappiness = 10" | sudo tee --append /etc/sysctl.conf
echo "fs.inotify.max_user_watches = 524288" | sudo tee --append /etc/sysctl.conf
```

## Sicurezza

Per sicurezza, rimuovere i permessi altrui dalla propria home:

```
chmod 0700 ~
chmod -R o-rwx ~
sed -i 's/#umask.\+/umask 0027/' ~/.profile
```

Tuttavia va ripristinato lo umask 0022 per il sudo:

```
cat <<'EOF' | sudo tee /etc/sudoers.d/umask
Defaults umask_override
Defaults umask=0022
EOF
sudo chmod 0440 /etc/sudoers.d/umask \
&& reboot
```

## Software di base

```
sudo apt update \
&& sudo apt install \
    vim \
    git \
    curl \
    tmux xclip \
    ripgrep \
    geany geany-plugin-lineoperations geany-plugin-prettyprinter geany-plugin-addons \
    filezilla \
    htop iotop \
    docker.io docker-compose make \
    meld \
    ncdu \
    network-manager-openvpn-gnome \
    gocryptfs \
&& sudo usermod -aG docker $USER \
&& snap install phpstorm --classic \
&& reboot
```

## Geany settings

Preferenze per Geany:

1. Editor > Caratteristiche > Marcatore di selezione del commento: togliere la tilda ~ e mettere
uno spazio, per compatibilità con i nostri standard e tutti gli altri editor.
2. Editor > Indentazione > Tipo: Spazi
3. File > Salvataggio File > Assicura fine riga consistenti
4. File > Salvataggio File > Elimina spazi e tabulazioni in coda

## PHP out-docker

```
sudo add-apt-repository ppa:ondrej/php \
&& sudo apt update \
&& sudo apt install \
    php7.4-bcmath php7.4-cli php7.4-common php7.4-curl php7.4-gd php7.4-imap php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-pcov php7.4-phpdbg php7.4-readline php7.4-sqlite3 php7.4-xml php7.4-zip \
&& mkdir ~/bin \
&& ( cd ~/bin && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php && php -r "unlink('composer-setup.php');" ) \
&& mv ~/bin/composer{.phar,} \
&& wget -O ~/bin/phive "https://phar.io/releases/phive.phar" \
&& chmod +x ~/bin/phive \
&& ~/bin/phive install --target /home/tessarotto/bin --trust-gpg-keys C00543248C87FB13,D2CCAC42F6295E7D,F4D32E2C9343B2AE composer-normalize composer-require-checker composer-unused
```
