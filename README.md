# Ansible Scaffold

## Setup

### Init git hooks
To avoid commiting accidentially sensible data unencrypted run following command.
```shell
$ make init-git-hooks
```

### Generate ssh key for ansible deploy user
run inside main directory
```shell
$ ssh-keygen -t ed25519 -C "ansible" -f $PWD/.ssh/id_ansible
$ cp .ssh/id_ansible .ssh/id_ansible.dist
$ make encrypt-ssh
```

copy private key for distribution 
```shell
$ cp .ssh/id_ansible .ssh/id_ansible.dist
```

encrypt distributed private key and set new vault password
```shell
$ make encrypt-ssh
```

### Create deploy user on target system and add public ssh key
```shell
$ useradd -m -s /bin/bash -G sudo deploy

$ add .ssh/id_ansible.pub > /home/deploy/.ssh/authorized_keys

$ chown -R deploy:deploy /home/deploy/.ssh/
$ chmod 700 /home/deploy/.ssh/
$ chmod 600 /home/deploy/.ssh/authorized_keys
$ passwd deploy
```

### Provice vault password file
Place .vault_pass file inside main directory to avoid providing ansible vault pass every run.

### Install roles/collections (optional)
Install useful roles from [ansible-galaxy](https://galaxy.ansible.com)
```shell
$ ansible-galaxy install -r requirements.yml
```

### Create own roles and variables
Any variable placed inside a *vaul.yml file will be automatically encrypted when you run
```shell
$ make encrypt-vault
```

### Run Playbook
Playbooks should be run with the following parameters.
Example: 
```shell
$ ansible-playbook -i hosts/prod.ini --vault-password-file .vault_pass --tags some-specific-tag --become(if root priviliges are required) playbook.yml
```
