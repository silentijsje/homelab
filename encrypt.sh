#!/bin/bash

VAULT_FILE=./ansible/vars/vault.yml
VAULT_PASSWORD_FILE=./ansible/.vault_pass

# Encrypt the file into an Ansible Vault file
ansible-vault encrypt "$VAULT_FILE" --vault-password-file "$VAULT_PASSWORD_FILE"

if [ $? -eq 0 ]; then
    echo "File $VAULT_FILE encrypted successfully."
else
    echo "Failed to encrypt the file $VAULT_FILE."
fi
