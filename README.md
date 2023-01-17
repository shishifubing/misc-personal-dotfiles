# [`misc-personal-dotfiles`][repo]

Things for personal use:

- [scripts] — shell scripts
- [configs] — configuration files
- [ansible] — ansible roles and playbooks
- [firefox] — firefox configuration files
- [vim] — vim configuration files

# Usage

```bash
DOTFILES="${DOTFILES:-${HOME}/Dotfiles}"
git clone                                                      \
    https://github.com/shishifubing-com/misc-personal-dotfiles \
    "${DOTFILES}"
"${DOTFILES}/scripts/setup.sh"
```

<!-- internal links -->

[scripts]: ./scripts
[configs]: ./configs
[ansible]: ./ansible
[firefox]: ./firefox
[vim]: ./vim

<!-- external links -->

[repo]: https://github.com/shishifubing-com/misc-personal-dotfiles

<!-- shield links -->

[shield-in-progress]: https://img.shields.io/badge/status-in--progress-success?style=for-the-badge
