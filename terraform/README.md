# Description

Personal terraform configs

---

# Architecture

TODO

---

# Usage

```bash
export PACKER_VARIABLES="" # define packer variables if you need to
make                       # build images, it is a wrapper for `packer build .`
terraform apply            # create infrastructure
```

---

# Setup

> **_NOTE:_** variables.pkr.hcl is a link to variables.tf to reuse terraform
> variables in packer builds

---

## Install tools, link .terraformrc

- terraform
- packer
- gitversion
- kubectl
- yc

```bash
#!/usr/bin/env bash
set -euxo pipefail
host="https://hashicorp-releases.yandexcloud.net"
github_url="https://github.com/GitTools/GitVersion/releases/download"

terraform_version="1.3.6"
packer_version="1.8.5"
gitversion_version="5.11.1"
kubectl_version=$(curl -Ls https://dl.k8s.io/release/stable.txt)

terraform_distrib="terraform_${terraform_version}_linux_amd64.zip"
packer_distrib="packer_${packer_version}_linux_amd64.zip"
gitversion_distrib="gitversion-linux-x64-${gitversion_version}.tar.gz"

wget "${host}/terraform/${terraform_version}/${terraform_distrib}"
wget "${host}/packer/${packer_version}/${packer_distrib}"
wget "${github_url}/${gitversion_version}/${gitversion_distrib}"
curl -LO "https://dl.k8s.io/release/${kubectl_version}/bin/linux/amd64/kubectl"

unzip "${terraform_distrib}"
unzip "${packer_distrib}"
tar -xvzf "${gitversion_distrib}"
rm -rf "${terraform_distrib}" "${packer_distrib}" "${gitversion_distrib}"
chmod +x terraform packer gitversion kubectl
sudo mv terraform packer gitversion kubectl /usr/bin/

ln -fs "${HOME}/Dotfiles/terraform/.terraformrc" "${HOME}/.terraformrc"
```

---

## Delegate domain

In order for cloud DNS to work, you need to delegate your domain to Yandex DNS servers:

- `ns1.yandexcloud.net`
- `ns2.yandexcloud.net`

Cloud DNS settings are located in [networking.tf][networking]

---

### Custom github.io domain

Conifigure the domain in [variables.tf][variables] and
[add it to Github Pages][github-pages]

---

## Setup kubectl access

Kubernetes cluster will be created after running `terraform apply`

```bash
echo "$(terraform output -raw ssh_config)" >> "${HOME}/.ssh/config"
# master does not have a public IP address, so you have to use port forwarding
ssh bastion -NL 8888:master.internal:443
# yandex cloud does not allow to pass ssh keys to master (on 2023-01-01),
# so you have to create admin account in UI
# set cluster
ca_file=$(mktemp)
echo "$(terraform output -raw cluster_ca)" > "${ca_file}"

kubectl config set-cluster               \
    yandex                               \
    --server="https://localhost:8888"    \
    --tls-server-name="kubernetes"       \
    --certificate-authority="${ca_file}" \
    --embed-certs="true"
# set user/password credentials
kubectl config set-credentials                                \
    personal                                                  \
    --exec-api-version="client.authentication.k8s.io/v1beta1" \
    --exec-command="yc"                                       \
    --exec-arg="k8s"                                          \
    --exec-arg="create-token"                                 \
    --exec-arg="--profile=default"
# set and switch to the context
kubectl config set-context \
    yandex                 \
    --cluster="yandex"     \
    --user="personal"      \
    --namespace="default"
kubectl config use-context yandex
```

---

# Documentation

- [Yandex Cloud][yandex-cloud] documentation

- [Terraform provider][terraform] documentation

- [Packer builder][packer] documentation

- `*.cloud-init.yml` files - [cloud-init][cloud-init] configuration files

---

<!-- internal links -->

[networking]: ./yandex_cloud/variables.tf

<!-- external links -->

[github-pages]: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site
[packer]: https://developer.hashicorp.com/packer/plugins/builders/yandex
[cloud-init]: https://cloudinit.readthedocs.io/en/latest/topics/examples.html
[terraform]: https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs
[yandex-cloud]: https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart
