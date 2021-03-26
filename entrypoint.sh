#!/bin/sh

set -e

configure_approle(){
    
    if [ ! -d /vault/config ]; then
        mkdir -p /vault/config
    fi

    if [ "${VAULT_ADDR}" == "" ]; then
        export VAULT_ADDR="https://vault.grupocr.local"
        export VAULT_CAPATH="/vault/config/cacerts"
    fi

    if [ "${VAULT_ROLE_ID}" != "" ]; then
        echo "${VAULT_ROLE_ID}" > /vault/config/roleid
    fi

    if [ "${VAULT_SECRET_ID}" != "" ]; then
        echo "${VAULT_SECRET_ID}" > /vault/config/secretid
    fi
}

run_agent(){
    
    vault agent -config=/vault/config.hcl >/dev/null 2>&1
    if [ -f /vault/secrets/output.json ]; then
        cat /vault/secrets/output.json > /dev/stdout
    fi
}

configure_approle

if [ "$1" = 'template' ]; then
    run_agent    
else
    exec "$@"
fi