FROM vault

LABEL com.pi2k Poliza Informatica 2000 MDS SL
LABEL maintainer Ruben Castro <rcastro@polizainformatica.com>
LABEL version v1.0.0
LABEL description Vault Agent Template

ENV APP_PATH=/rancheros-vault-template

COPY [ "./", "/${APP_PATH}/" ]

RUN apk add --no-cache sudo && \
    chmod +x /vault/entrypoint.sh && \
    addgroup -g 1100 rancher && \
    adduser -h /home/rancher -s /bin/sh -G rancher -u 1100 -D rancher && \
    echo "rancher ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/rancheros-git

VOLUME [ "/${APP_PATH}/templates" ]
WORKDIR ${APP_PATH}

USER rancher

ENTRYPOINT [ ".entrypoint.sh" ]

CMD [ "template" ]