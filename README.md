# Let's crypt自动签发SSL证书脚本

## 使用方法

1. 运行`install.sh`

2. 打开`config/domains.txt`

    每行一个域名，不能使用通配符

3. 配置nginx

    在`/etc/nginx/snippets`下新建`letscrypt.conf`文件，写入以下内容，将`/srv/www/letscrypt/runtime/challenges`换成你的对应路径
    
    ```nginx
    location /.well-known/acme-challenge/ {
        alias      /srv/www/letscrypt/runtime/challenges;
        try_files  $uri =404;
    }
    ```
    
    在`/etc/nginx/snippets`下新建`https.conf`文件，写入以下内容，将`/srv/www/letscrypt/secret/`等等换成你的对应路径

    ```nginx
    ssl_certificate      /srv/www/letscrypt/secret/chained.pem;
    ssl_certificate_key  /srv/www/letscrypt/secret/domain.key;
    ```
    
    方案一，访问网站仅使用https，所有http自动跳转到https

    首先修改`/etc/nginx/sites-available/default`

    ```nginx
    server {
        listen       80 default_server;
        server_name  _;
        root         /var/www/html;
        index        index.html index.htm index.nginx-debian.html;

        access_log   /var/log/nginx/default.access.log;
        error_log    /var/log/nginx/default.error.log;

        include      snippets/letscrypt.conf;

        location / {
            return   301 https://$host$request_uri;
        }
    }
    ```

    修改对应的网站，如`/etc/nginx/sites-available/www.example.com`

    ```nginx
    server {
        listen       443 ssl;
        server_name  www.example.com;
        root         /srv/www/www.example.com;
        index        index.php;

        access_log   /var/log/nginx/www.access.log;
        error_log    /var/log/nginx/www.error.log;
        
        # ...

        include      snippets/https.conf;
    }
    ```

    方案二，http和https均可访问网站
    
    修改对应的网站，如`/etc/nginx/sites-available/www.example.com`

    ```nginx
    server {
        listen       80;
        listen       443 ssl;
        server_name  www.example.com;
        root         /srv/www/www.example.com;
        index        index.php;

        access_log   /var/log/nginx/www.example.com.access.log;
        error_log    /var/log/nginx/www.example.com.error.log;
        
        # ...

        include      snippets/letscrypt.conf;
        include      snippets/https.conf;
    }
    ```

4. 重启Nginx

    ```bash
    sudo service nginx reload
    ```

5. 运行`renew_cert.sh`

6. 再次重启Nginx

    ```bash
    sudo service nginx reload
    ```

## 参考文献

<https://github.com/diafygi/acme-tiny/>

<https://imququ.com/post/letsencrypt-certificate.html>

## CONTRIBUTORS

* Ganlv <ganlvtech@qq.com>

## LICENSE

    The MIT License (MIT)

    Copyright (c) 2017 Ganlv

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
