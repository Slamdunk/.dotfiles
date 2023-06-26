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

## Software di base

```
sudo apt update \
&& sudo apt install \
    vim vim-gtk3 \
    git \
    curl \
    tmux xclip \
    ripgrep \
    geany geany-plugin-lineoperations geany-plugin-prettyprinter geany-plugin-addons \
    htop iotop \
    docker.io docker-compose make \
    meld \
    ncdu \
    network-manager-openvpn-gnome \
&& sudo usermod -aG docker $USER
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
    php8.2-bcmath php8.2-cli php8.2-common php8.2-curl php8.2-gd php8.2-mbstring php8.2-mysql php8.2-opcache php8.2-pcov php8.2-readline php8.2-sqlite3 php8.2-xd
ebug php8.2-xml php8.2-zip \
&& mkdir ~/bin \
&& ( cd ~/bin && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php && php -r "unlink('composer-setup.php');" ) \
&& mv ~/bin/composer{.phar,} \
&& wget -O ~/bin/composer-normalize https://github.com/ergebnis/composer-normalize/releases/latest/download/composer-normalize.phar \
&& wget -O ~/bin/composer-require-checker https://github.com/maglnet/ComposerRequireChecker/releases/latest/download/composer-require-checker.phar \
&& wget -O ~/bin/composer-unused https://github.com/composer-unused/composer-unused/releases/latest/download/composer-unused.phar \
&& chmod +x ~/bin/composer-*
```
