# Description

Personal terraform configs

# Setup

## Install terraform

```bash
version="1.3.6"
host="https://hashicorp-releases.yandexcloud.net"
wget                                                                    \
    -O terraform.zip                                                    \
    "${host}/terraform/${version}/terraform_${version}_linux_amd64.zip"
unzip terraform.zip
rm -rf terraform.zip
chmod +x terraform
sudo mv terraform /usr/bin/
ln -fs "${HOME}/Dotfiles/terraform/.terraformrc" "${HOME}/.terraformrc"
```

## Delegate domen

In order for cloud DNS to work, you need to delegate you doment to Yandex DNS servers:

- `ns1.yandexcloud.net`
- `ns2.yandexcloud.net`

You can change variable `domain` if needed
