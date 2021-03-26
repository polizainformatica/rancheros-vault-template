FROM vault

LABEL com.pi2k Poliza Informatica 2000 MDS SL
LABEL maintainer Ruben Castro <rcastro@polizainformatica.com>
LABEL version v1.0.0
LABEL description Vault Agent Template

COPY [ "./config/", "./config.hcl", "./entrypoint.sh", "./README.md", "/vault-template/" ]

RUN apk add --no-cache sudo && \
    chmod +x /vault-template/entrypoint.sh && \
    addgroup -g 1100 rancher && \
    adduser -h /home/rancher -s /bin/sh -G rancher -u 1100 -D rancher && \
    chown -R rancher:rancher /vault-template && \
    echo "rancher ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vault-template

VOLUME [ "/vault-template/templates" ]
WORKDIR /vault-template

USER rancher

ENTRYPOINT [ "./entrypoint.sh" ]

CMD [ "template" ]