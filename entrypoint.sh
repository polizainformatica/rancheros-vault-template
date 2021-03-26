#!/bin/sh

set -e

configure_approle(){
    
    if [ ! -d "/${APP_PATH}/config" ]; then
        mkdir -p "/${APP_PATH}/config"
    fi

    if [ "${VAULT_ADDR}" == "" ]; then
        export VAULT_ADDR="https://vault.grupocr.local"
        export VAULT_CAPATH="/${APP_PATH}/config/cacerts"
    fi

    if [ "${VAULT_ROLE_ID}" != "" ]; then
        sudo echo "${VAULT_ROLE_ID}" > /${APP_PATH}/config/roleid
    fi

    if [ "${VAULT_SECRET_ID}" != "" ]; then
        sudo echo "${VAULT_SECRET_ID}" > /${APP_PATH}/config/secretid
    fi
}

run_agent(){
    
    vault agent -config=/${APP_PATH}/config.hcl >/dev/null 2>&1
    if [ -f /${APP_PATH}/secrets/output.json ]; then
        cat /${APP_PATH}/secrets/output.json > /dev/stdout
    fi
}

configure_approle

if [ "$1" = 'template' ]; then
    run_agent    
else
    exec "$@"
fi