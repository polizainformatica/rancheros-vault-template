# rancheros-vault-template

A tool for export secrets formated by a template file from HashiCorp Vault to stdout using Docker in Rancheros

## Supported tags and Dockerfile links

-	[`latest` (*Dockerfile*)](https://github.com/rcastropolizainformatica/rancheros-vault-template/blob/main/Dockerfile)
-	[`v1.0.0` (*Dockerfile*)](https://github.com/rcastropolizainformatica/rancheros-vault-template/blob/v1.0.0/Dockerfile)

## Template file

The container requires a valid Vault template. See https://github.com/hashicorp/consul-template/blob/master/docs/templating-language.md#secret

template.tpl
```
{{ with secret "secret/my-secret" }}
{{ .Data.data.foo }}
{{ end }}
```

# How to use

### Command Line

```bash
docker build -t rancheros-vault-template .
docker run -it --rm --cap-add IPC_LOCK \
    -e VAULT_ADDR="http://your.vault.server:8200" \
    -e VAULT_ROLE_ID="your_role_id" \
    -e VAULT_SECRET_ID="your_secret_id" \
    -v /path/to/your-template.tpl:/vault-template/templates/template.tpl:ro \
    rancheros-vault-template > secret
```

```bash
docker build -t rancheros-vault-template .
docker run -it --rm --cap-add IPC_LOCK \
    -e VAULT_ADDR="http://your.vault.server:8200" \
    -v /path/to/your-template.tpl:/vault-template/templates/template.tpl:ro \
    -v /path/to/roleid:/vault-template/config/roleid:ro \
    -v /path/to/secretid:/vault-template/config/secretid:ro \
    rancheros-vault-template > secret
```