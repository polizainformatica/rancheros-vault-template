#!/bin/sh

set -e

configure_approle(){
    
    if [ ! -d "/vault-template/config" ]; then
        mkdir -p "/vault-template/config"
    fi

    if [ "${VAULT_ADDR}" == "" ]; then
        export VAULT_ADDR="https://vault.grupocr.local"
        export VAULT_CAPATH="/vault-template/config/cacerts"
    fi

    if [ "${VAULT_ROLE_ID}" != "" ]; then
        sudo echo "${VAULT_ROLE_ID}" > /vault-template/config/roleid
    fi

    if [ "${VAULT_SECRET_ID}" != "" ]; then
        sudo echo "${VAULT_SECRET_ID}" > /vault-template/config/secretid
    fi
}

run_agent(){
    
    vault agent -config=/vault-template/config.hcl >/dev/null 2>&1
    if [ -f /vault-template/secrets/output.json ]; then
        cat /vault-template/secrets/output.json > /dev/stdout
    fi
}

configure_approle

if [ "$1" = 'template' ]; then
    run_agent    
else
    exec "$@"
fi