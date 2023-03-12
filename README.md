<div align="center" markdown="1">

# [`misc-personal-dotfiles`][url-repo]

[![License][badge-license]][url-license]
[![Conventional Commits][badge-conventionalcommits]][url-conventionalcommits]

Miscellaneous things for personal use

</div>

## About The Project

### Contents

- [scripts] — shell scripts
- [configs] — configuration files
- [ansible] — ansible roles and playbooks
- [firefox] — firefox configuration files
- [vim] — vim configuration files

## Usage

```bash
export DOTFILES="${DOTFILES:-${HOME}/Dotfiles}"
url="https://raw.githubusercontent.com/shishifubing/misc-personal-dotfiles/main/scripts/setup.sh"
curl -sSL "${url}" | bash
```

<!-- relative links -->

[scripts]: scripts
[configs]: configs
[ansible]: ansible
[firefox]: firefox
[vim]: vim

<!-- project links -->

[url-repo]: https://github.com/shishifubing/misc-personal-dotfiles
[url-license]: https://github.com/shishifubing/misc-personal-dotfiles/blob/main/LICENSE

<!-- external links -->

[url-conventionalcommits]: https://conventionalcommits.org

<!-- badge links -->

[badge-license]: https://img.shields.io/github/license/shishifubing/misc-personal-dotfiles.svg
[badge-conventionalcommits]: https://img.shields.io/badge/conventional-commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white
