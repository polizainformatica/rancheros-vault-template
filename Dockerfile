FROM vault

LABEL com.pi2k Poliza Informatica 2000 MDS SL
LABEL maintainer Ruben Castro <rcastro@polizainformatica.com>
LABEL version v1.0.0
LABEL description Vault Agent Template

COPY [ "./", "/vault/" ]

RUN apk add --no-cache sudo && \
    chmod +x /vault/entrypoint.sh && \
    addgroup -g 1100 rancher && \
    adduser -h /home/rancher -s /bin/sh -G rancher -u 1100 -D rancher && \
    echo "rancher ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/rancheros-git
    
VOLUME [ "/vault/templates" ]
WORKDIR /vault

USER rancher

ENTRYPOINT [ "/vault/entrypoint.sh" ]

CMD [ "template" ]