ifneq (,$(wildcard .vault_pass))
	ANSIBLE_VAULT_ARG := --vault-password-file .vault_pass
else
	ANSIBLE_VAULT_ARG := --ask-vault-pass
endif

.PHONY: init-git-hooks
init-git-hooks:
	git config core.hooksPath .githooks

.PHONY: encrypt-vault
encrypt-vault:
	ansible-vault encrypt $(ANSIBLE_VAULT_ARG) ./group_vars/**/*vault.yml

.PHONY: decrypt-vault
decrypt-vault:
	ansible-vault decrypt $(ANSIBLE_VAULT_ARG) ./group_vars/**/*vault.yml

.PHONY: encrypt-ssh
encrypt-ssh:
	ansible-vault encrypt $(ANSIBLE_VAULT_ARG) ./.ssh/id_ansible.dist

.PHONY: decrypt-ssh
decrypt-ssh:
	ansible-vault decrypt $(ANSIBLE_VAULT_ARG) ./.ssh/id_ansible.dist

.PHONY: create-decrypted-ssh-key
create-decrypted-ssh-key:
	ansible-vault decrypt $(ANSIBLE_VAULT_ARG) --output=./.ssh/id_ansible ./.ssh/id_ansible.dist
	chmod 0600 ./.ssh/id_ansible

