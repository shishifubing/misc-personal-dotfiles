#!/usr/bin/env bash
set -Eeuxo pipefail

terraform_version="1.3.6"
packer_version="1.8.5"
gitversion_version="5.11.1"
kubectl_version=$(curl -Ls https://dl.k8s.io/release/stable.txt)

host="https://hashicorp-releases.yandexcloud.net"
github_url="https://github.com/GitTools/GitVersion/releases/download"
dotfiles_repo="https://github.com/jingyangzhenren/config-personal-dotfiles.git"
dotfiles_dir="${HOME}/Dotfiles"
config_dir="${dotfiles_dir}/terraform/yandex_cloud"

terraform_distrib="terraform_${terraform_version}_linux_amd64.zip"
packer_distrib="packer_${packer_version}_linux_amd64.zip"
gitversion_distrib="gitversion-linux-x64-${gitversion_version}.tar.gz"

wget "${host}/terraform/${terraform_version}/${terraform_distrib}"
wget "${host}/packer/${packer_version}/${packer_distrib}"
wget "${github_url}/${gitversion_version}/${gitversion_distrib}"
curl -LO "https://dl.k8s.io/release/${kubectl_version}/bin/linux/amd64/kubectl"
git clone "${dotfiles_repo}" "${dotfiles_dir}" || {
    git --git-dir "${dotfiles_repo}/.git" pull
}
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash

unzip "${terraform_distrib}"
unzip "${packer_distrib}"
tar -xvzf "${gitversion_distrib}"
rm -rf "${terraform_distrib}" "${packer_distrib}" "${gitversion_distrib}"
chmod +x terraform packer gitversion kubectl
sudo mv terraform packer gitversion kubectl /usr/bin/

ln -fs "${dotfiles_dir}/terraform/.terraformrc" "${HOME}/.terraformrc"
ln -fs "${dotfiles_dir}/scripts/bashrc.sh" "${HOME}/.bashrc"
mkdir -pm 700 "${HOME}/Credentials/yc"
cd "${config_dir}"
terraform get
terraform init