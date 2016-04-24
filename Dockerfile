FROM ubuntu:14.04

ARG vault_token
#ARG vault_addr

RUN apt-get update && \
    apt-get install -y --force-yes nginx curl vim

RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 -o /usr/bin/confd && \
    chmod +x /usr/bin/confd && \
    rm /etc/nginx/sites-enabled/default && \
    mkdir -p /etc/confd/{conf.d,templates}

RUN mkdir -p /certificates && \
    curl -L http://stedolan.github.io/jq/download/linux64/jq > /usr/bin/jq && \
    chmod 777 /usr/bin/jq && \
    curl -H "X-Vault-Token: ${vault_token}" -X GET http://141.138.204.179:8200/v1/etcd/coreos_pem | jq -r '.data.value' > /certificates/coreos_cert.pem && \
    curl -H "X-Vault-Token: ${vault_token}" -X GET http://141.138.204.179:8200/v1/etcd/coreos_ca_pem | jq -r '.data.value' > /certificates/coreos_ca.pem && \
    curl -H "X-Vault-Token: ${vault_token}" -X GET http://141.138.204.179:8200/v1/etcd/coreos_key_pem | jq -r '.data.value' > /certificates/coreos_key.pem && \
    chmod -R 755 /certificates

COPY nginx.toml /etc/confd/conf.d/nginx.toml
COPY nginx.tmpl /etc/confd/templates/nginx.tmpl
COPY nginx.conf /etc/nginx/nginx.conf
COPY confd-watch /usr/local/bin/confd-watch
COPY etcd.sh /usr/local/bin/etcd

RUN chmod a+x /usr/local/bin/confd-watch && chmod a+x /usr/local/bin/etcd

EXPOSE 80
