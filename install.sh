#!/bin/bash
BASEDIR=$(dirname $0)
pushd $BASEDIR



# 创建文件夹

if [ ! -e config/ ];then
    mkdir config/
fi

if [ ! -e runtime/ ];then
    mkdir runtime/
fi

if [ ! -e secret/ ];then
    mkdir secret/
fi



# 配置文件

cd config/

if [ ! -e domains.txt ];then
    touch domains.txt
fi

cd ..



# 运行时文件

cd runtime/

if [ ! -e acme_tiny.py ];then
    wget https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py
fi

if [ ! -e lets-encrypt-x3-cross-signed.pem ];then
    wget https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem
fi

if [ ! -e challenges/ ];then
    mkdir challenges/
fi

cd ../



# 重要文件（请注意保密）

cd secret/

if [ ! -e account.key ];then
    openssl genrsa 4096 > account.key
fi

if [ ! -e domain.key ];then
    openssl genrsa 4096 > domain.key
fi

cd ../




popd
