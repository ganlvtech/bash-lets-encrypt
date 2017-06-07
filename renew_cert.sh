#!/bin/bash
BASEDIR=$(dirname $0)
pushd $BASEDIR



# 如果缺少文件则先重新下载

./install.sh



# 创建CSR（Certificate Signing Request，证书签名请求）文件

SAN=$(cat config/domains.txt | sed '/^$/d' | sed '/^#/d' | sed 's/\(.*\)/DNS:\1/' | tr '\n' ',' | sed 's/,$//')
SAN=$(printf "[SAN]\nsubjectAltName=$SAN\n")
(cat openssl.cnf ; echo "$SAN") > runtime/domain_ssl.cnf
openssl req -new -sha256 -key secret/domain.key -subj "/" -reqexts SAN -config runtime/domain_ssl.cnf > runtime/domain.csr



# 运行ACME（Automatic Certificate Management Environment）脚本

python runtime/acme_tiny.py --account-key secret/account.key --csr runtime/domain.csr --acme-dir runtime/challenges/ > runtime/signed.crt || exit



# 合成证书链

cat runtime/signed.crt runtime/lets-encrypt-x3-cross-signed.pem > secret/chained.pem



popd
