#!/bin/bash

VAULT_FILE=./ansible/vars/vault.yml
IMMICH_ENV_FILE=./ansible/files/prod-video01/immich/env
VAULT_PASSWORD_FILE=./ansible/.vault_pass

# Decrypt the Ansible Vault file
ansible-vault decrypt "$VAULT_FILE" --vault-password-file "$VAULT_PASSWORD_FILE"
ansible-vault decrypt "$IMMICH_ENV_FILE" --vault-password-file "$VAULT_PASSWORD_FILE"

if [ $? -eq 0 ]; then
    echo "Vault file $VAULT_FILE decrypted successfully."
else
    echo "Failed to decrypt the vault file $VAULT_FILE."
fi