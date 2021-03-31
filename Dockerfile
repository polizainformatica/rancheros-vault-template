FROM vault:1.7.0

LABEL com.pi2k Poliza Informatica 2000 MDS SL
LABEL maintainer Ruben Castro <rcastro@polizainformatica.com>
LABEL version v1.0.0
LABEL description Vault Agent Template

RUN apk add --no-cache sudo && \
    addgroup rancher && \
    adduser -h /home/rancher -s /bin/sh -G rancher -D rancher && \
    echo "rancher ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vault-template

WORKDIR /app
COPY [ "./config.hcl", "./entrypoint.sh", "./" ]
COPY [ "./config/", "./config/" ]

USER rancher

ENTRYPOINT [ "/app/entrypoint.sh" ]
CMD [ "-h" ]