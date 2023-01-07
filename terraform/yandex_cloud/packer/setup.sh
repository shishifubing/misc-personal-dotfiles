#!/usr/bin/env bash
set -Eeuxo pipefail

host="https://hashicorp-releases.yandexcloud.net"
github_url="https://github.com/GitTools/GitVersion/releases/download"
dotfiles_repo="https://github.com/jingyangzhenren/config-personal-dotfiles.git"
helm_url="https://get.helm.sh"
yc_url="https://storage.yandexcloud.net/yandexcloud-yc"

terraform_version="1.3.7"
packer_version="1.8.5"
gitversion_version="5.11.1"
kubectl_version=$(curl -Ls https://dl.k8s.io/release/stable.txt)
helm_version="v3.10.3"
yc_version=$(curl -Ls "${yc_url}/release/stable")


dotfiles_dir="${HOME}/Dotfiles"
config_dir="${dotfiles_dir}/terraform/yandex_cloud"

terraform_distrib="terraform_${terraform_version}_linux_amd64.zip"
packer_distrib="packer_${packer_version}_linux_amd64.zip"
gitversion_distrib="gitversion-linux-x64-${gitversion_version}.tar.gz"
helm_distrib="helm-${helm_version}-linux-amd64.tar.gz"

temp=$(mktemp -d)
current="${PWD}"
cd "${temp}"

wget "${host}/terraform/${terraform_version}/${terraform_distrib}"
wget "${host}/packer/${packer_version}/${packer_distrib}"
wget "${github_url}/${gitversion_version}/${gitversion_distrib}"
curl -LO "https://dl.k8s.io/release/${kubectl_version}/bin/linux/amd64/kubectl"
curl -LO "${yc_url}/release/${yc_version}/linux/amd64/yc"
wget "${helm_url}/${helm_distrib}"

git clone "${dotfiles_repo}" "${dotfiles_dir}" || {
    git --git-dir "${dotfiles_dir}/.git" pull
}

unzip "${terraform_distrib}"
unzip "${packer_distrib}"
tar -xvzf "${helm_distrib}"
mv ./*/helm ./
tar -xvzf "${gitversion_distrib}"
chmod +x terraform packer gitversion kubectl yc helm
sudo mv terraform packer gitversion kubectl yc helm /usr/bin/

cd "${current}"
rm -rf "${temp}"

"${dotfiles_dir}/scripts/setup_links.sh"
mkdir -pm 700 "${HOME}/Credentials/yc"
cd "${config_dir}"
terraform get
terraform init -backend=false