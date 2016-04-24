#!/bin/bash
curl --cacert /etc/ssl/certs/coreos_ca.pem --key /etc/ssl/certs/coreos_key.pem --cert /etc/ssl/certs/coreos_cert.pem -L $1
