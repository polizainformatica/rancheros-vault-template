#!/bin/sh

set -e

mainHelpFunction(){

    echo -e "\nUsage: [OPTIONS] COMMAND\n" \
        "\nHashicorp Vault agent\n" \
        "\nOptions:\n\n" \
        "\t-h        show this help message and exit\n" \
        "\nCommands:\n\n" \
        "\ttemplate  export secret using a template\n\n" 1>&2
}

templateHelpFunction(){

    echo -e "\nUsage: [OPTIONS] FILE\n" \
        "\nExport secret to stdio using a template\n" \
        "\nOptions:\n\n" \
        "\t-h        show this help message and exit\n\n" 1>&2
}

configure_vault_agent(){
    
    if [ "${VAULT_ADDR}" == "" ]; then
        export VAULT_ADDR="https://vault.grupocr.local"
        export VAULT_CAPATH="/app/config/cacerts"
    fi

    if [ "${VAULT_ROLE_ID}" != "" ]; then
        echo "${VAULT_ROLE_ID}" > /home/rancher/roleid
    fi

    if [ "${VAULT_SECRET_ID}" != "" ]; then
        echo "${VAULT_SECRET_ID}" > /home/rancher/secretid
    fi
}

clean_vault_agent(){

    if [ -f "/home/rancher/roleid" ]; then
        rm -f /home/rancher/roleid
    fi
    if [ -f "/home/rancher/secretid" ]; then
        rm -f /home/rancher/secretid
    fi
    if [ -f "/home/rancher/secret.out" ]; then
        rm -f /home/rancher/secret.out
    fi
}

command_template(){

    while getopts ":h" opt; do
        case ${opt} in
            h) 
                templateHelpFunction
                exit 0
                ;;
            ?)
                echo ""
                echo "Invalid Option: -$OPTARG" 1>&2
                templateHelpFunction
                exit 1
                ;;
        esac
    done
    shift $((OPTIND -1))

    if [ -f "$1" ]; then
        cp "$1" /home/rancher/template.in
        run_agent
    else
        echo ""
        echo "Command template requires a valid template file"
        templateHelpFunction
        exit 1
    fi
}

run_agent(){
    
    configure_vault_agent
    vault agent -config=/app/config.hcl >/dev/null 2>&1
    if [ -f /home/rancher/secret.out ]; then
        cat /home/rancher/secret.out > /dev/stdout
    fi
    clean_vault_agent >/dev/null 2>&1
}

# Main
while getopts ":h" opt; do
    case ${opt} in
        h) 
            mainHelpFunction
            exit 0
            ;;
        ?)
            echo "\nInvalid option: -$OPTARG" 1>&2
            mainHelpFunction
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

# Command
command=$1; shift
case "$command" in
    template)
        command_template "$@"
        ;;
    *)
        echo "\nInvalid command $command" 1>&2
        mainHelpFunction
        exit 1
        ;;
esac
