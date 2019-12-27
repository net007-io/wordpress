# Wordpress

Wordpress一键安装脚本。

## 使用方法
- 为了方便，全程使用root用户操作：sudo su root
- 设置申请证书的环境变量，这里使用[acme.sh](https://github.com/Neilpang/acme.sh)申请letsencrypt的证书，参考[教程](https://github.com/Neilpang/acme.sh/wiki/%E8%AF%B4%E6%98%8E)。
  - 使用Cloudflare的DNS服务
    - export CF_Token="******"
    - export CF_Account_ID="******"
  - 使用DNSPOD的DNS服务
    - export DP_Id="******"
    - export DP_Key="******"
  - 其他DNS服务商请参考[教程](https://github.com/Neilpang/acme.sh/wiki/dnsapi)
- 编辑docker-compose.example.yml文件，设置mysql用户和密码。
- 编辑default.example.conf，这是nginx的配置文件，根据需要更改配置。
- bash deploy.sh DOMAIN（DOMAIN为你的域名）
