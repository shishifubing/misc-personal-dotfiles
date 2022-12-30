# Description

Personal ansible playbooks

# Usage

The default inventory is defined in `ansible.cfg` - `inventory/main.yml`

```bash
python3 -m venv venv
. venv/bin/activate
pip install ansible
ansible-galaxy install -r requirements.yml
ansible-playbook --skip-tags setup deploy_sonarqube_runner.yml
ansible-playbook -i custom_inventory.yml -l custom_range deploy_github_runner.yml
ansible-playbook setup_personal.yml
```
