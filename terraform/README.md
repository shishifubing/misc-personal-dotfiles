# Description

Personal terraform configs

---

# Architecture

TODO

---

# Usage

```bash
# define packer variables if you need to
export PACKER_VARIABLES=""
# build images and create infrastructure
make
# ssh to the bastion host and check cluster connectivity
ssh bastion
kubectl cluster-info
```

---

# Setup

> **_NOTE:_** variables.pkr.hcl is a link to variables.tf to reuse terraform
> variables in packer builds

- terraform
- packer
- gitversion
- kubectl
- yc

```bash
# install tools, link .terraformrc
# it is mainly a server setup script, so there might be side effects
./setup.sh
# build images and create infrastructure
make
# setup ssh
echo "$(terraform output -raw ssh_config)" >>"${HOME}/.ssh/config"
# setup kubectl on the bastion host and create admin user in the cluster
# the script is included in the VM image built by packer
ssh bastion "./setup_kubectl.sh"
```

---

## Delegate domain

In order for public Cloud DNS to work with your domain, you need to delegate it to Yandex DNS servers:

- `ns1.yandexcloud.net`
- `ns2.yandexcloud.net`

Cloud DNS settings are located in [networking.tf][networking]

---

## Invalid certificate status: VALIDATING

If `terraform apply` fails because of that reason, you need to wait untill
Let's Encrypt validates load balancer's certificate

It may take several minutes

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
