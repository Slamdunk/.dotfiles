# .dotfiles

Shell, git, tmux, vim and wget settings for modern Debian/Ubuntu (Debian 12+, Ubuntu 22.04+).

```
wget --output-document=- "https://github.com/Slamdunk/.dotfiles/archive/master.tar.gz" | tar -xz \
  && .dotfiles-master/install.sh \
  && rm -rv .dotfiles-master/
```

`install.sh` shows a diff and asks before overwriting each existing file;
use `install.sh --non-interactive` to overwrite without asking.
At the end it prints the `apt install` line for any missing package the settings rely on.

Machine-specific git settings (`user.name`, `user.email`, signing key, ...) go in the untracked `~/.gitconfig.local`:

```
git config --file ~/.gitconfig.local user.name  "Your Name"
git config --file ~/.gitconfig.local user.email "you@example.com"
```
