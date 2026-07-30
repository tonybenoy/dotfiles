# dotfiles

zsh + powerlevel10k config for Arch Linux and Arch-based distros, also used
under WSL2. WSL-specific bits self-disable on native Linux.

## Prerequisites

`setup.sh` installs packages but not the tools it needs to do so. Have these
first:

| Need | Why |
| --- | --- |
| Arch or Arch-based distro | `setup.sh` shells out to `yay` |
| [`yay`](https://github.com/Jguer/yay) | AUR helper; **not** installed by the script |
| `git`, `gnupg` | cloning, and commit signing (`commit.gpgsign = true`) |

## Install

```bash
git clone https://github.com/tonybenoy/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

HTTPS is deliberate here: the `https` → `ssh` rewrite lives in the `.gitconfig`
this repo installs, so it isn't active yet and the first clone needs no SSH key.
Afterwards every GitHub URL is rewritten — see step 4.

Run it **from the repo root** — symlink targets are built from `$PWD`, so
running it from elsewhere creates links pointing at the wrong place.

It is idempotent; re-run it after a `git pull` to pick up new files.

### What it does

Installs `zsh`, `oh-my-zsh-git`, `zsh-fast-syntax-highlighting-git`,
`zsh-autosuggestions-git`, `zsh-theme-powerlevel10k-git`,
`ttf-meslo-nerd-font-powerlevel10k`, `eza`, `bat`, `fzf` — then symlinks:

```
~/.zshrc  ~/.zshenv  ~/.bashrc  ~/.bashrc.aliases  ~/.p10k.zsh  ~/.gitconfig
~/.config/git/ignore
```

## New machine checklist

`setup.sh` deliberately stops at packages and symlinks. These steps are manual,
and roughly in the order you'll want them.

### 1. Make zsh your login shell

The script installs zsh but does not change your shell — you will still land in
bash until you do:

```bash
chsh -s "$(command -v zsh)"
```

Log out and back in for it to take effect.

### 2. Set the terminal font to MesloLGS NF

`.p10k.zsh` runs in `awesome-fontconfig` mode, so it assumes a Nerd Font. The
package is installed for you, but selecting it in your terminal emulator is
manual. Without it the prompt renders as boxes and question marks.

On WSL this is a **Windows Terminal** setting (Profile → Appearance → Font
face), not a Linux one.

### 3. GPG signing

`commit.gpgsign = true` is unconditional, so **every commit fails until a
signing key exists**. Import or generate your key, then point `.gitconfig` at
whatever ID it has on this machine:

```bash
./configGpg.sh    # rewrites signingkey to this machine's key ID
```

This edits the tracked `.gitconfig`, leaving the repo dirty. Before committing
anything from *this* repo, restore the committed default so you don't push a
machine-specific key ID:

```bash
./resetGpg.sh
```

Both scripts refuse to run if no key is found, rather than blanking the field.
They must also be run from the repo root.

If signing fails with `Inappropriate ioctl for device`, the agent needs a TTY —
`startgpg` exports `GPG_TTY` and makes a throwaway signature to prime it.

### 4. SSH key

`.gitconfig` rewrites `https://github.com/` to `ssh://git@github.com/`, so
**all** GitHub traffic uses SSH — including public clones. Put your key at
`~/.ssh/tony` (the path `startssh` expects), lock it down, and register it with
GitHub:

```bash
chmod 600 ~/.ssh/tony
ssh -T git@github.com    # verify
```

There is no persistent agent socket, so run `startssh` once per terminal before
pushing or pulling.

### 5. npm prefix

`.zshrc` and `.bashrc` put `~/.npm-global/bin` on `PATH`, but npm has to be
told to install there:

```bash
npm config set prefix ~/.npm-global
```

> **Never commit `~/.npmrc`.** It holds registry auth tokens as plaintext. It is
> intentionally untracked; only the `prefix` line above is worth reproducing.

### 6. Python

Python tooling is [uv](https://github.com/astral-sh/uv). Nothing to configure —
uv creates in-project `.venv` directories by default, which is what the old
poetry config here existed to force.

### 7. Optional extras

`.zshrc` adds `~/.opencode/bin` and `~/.sigyn/bin` to `PATH`. Both are
installed separately; the entries are harmless if the directories don't exist.

## Troubleshooting

| Symptom | Cause |
| --- | --- |
| Still in bash after setup | `chsh` not run, or no re-login — step 1 |
| Prompt shows boxes / `?` glyphs | Terminal font isn't MesloLGS NF — step 2 |
| `gpg failed to sign the data` | No key, or agent has no TTY — step 3, or run `startgpg` |
| `Could not open a connection to your authentication agent` | Run `startssh` — step 4 |
| `git push` asks for a password | SSH key not registered with GitHub — step 4 |
| Globally installed npm binaries not found | `prefix` not set — step 5 |

## Notes

- `zsh-autocomplete` is intentionally absent: its history-search widget clashes
  with oh-my-zsh's `fzf` plugin.
- `fast-syntax-highlighting` is sourced *after* `oh-my-zsh.sh`; sourcing it
  earlier lets oh-my-zsh overwrite its ZLE widgets.
- `~/.config/git/ignore` is tracked here, so global excludes follow the repo.
- `ls` is aliased to `eza -la` and `cat` to `bat`. `eza` is the maintained fork
  of `exa`, which has been removed from the Arch repos.
