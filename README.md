# [`misc-personal-dotfiles`](https://github.com/shishifubing-com/misc-personal-dotfiles)

Things for personal use:

- [scripts](/scripts): shell scripts
- [configs](/configs): configuration files
- [ansible](/ansible): ansible roles and playbooks
- [firefox](/firefox): firefox configuration files
- [vim](/vim/): vim configuration files

# Usage

```bash
DOTFILES="${DOTFILES:-${HOME}/Dotfiles}"
git clone                                                      \
    https://github.com/shishifubing-com/misc-personal-dotfiles \
    "${DOTFILES}"
"${DOTFILES}/scripts/setup.sh"
```
