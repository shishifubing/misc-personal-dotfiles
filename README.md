# [`misc-personal-dotfiles`][repo]

<!-- shields -->

[![shield-in-progress]][repo]

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

# SCC overview

```
───────────────────────────────────────────────────────────────────────────────
Language                 Files     Lines   Blanks  Comments     Code Complexity
───────────────────────────────────────────────────────────────────────────────
Shell                       34      2386      552       411     1423        145
YAML                        13       314       30        12      272          0
Markdown                     7        74       20         0       54          0
Vim Script                   6       642      107       252      283          7
CSS                          5      1620       38       369     1213          0
JSON                         4       320        0         0      320          0
gitignore                    2       140       26        37       77          0
License                      1       661      117         0      544          0
Plain Text                   1        11        0         0       11          0
───────────────────────────────────────────────────────────────────────────────
Total                       73      6168      890      1081     4197        152
───────────────────────────────────────────────────────────────────────────────
Estimated Cost to Develop (organic) $121,809
Estimated Schedule Effort (organic) 6.18 months
Estimated People Required (organic) 1.75
───────────────────────────────────────────────────────────────────────────────
Processed 195686 bytes, 0.196 megabytes (SI)
───────────────────────────────────────────────────────────────────────────────
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
