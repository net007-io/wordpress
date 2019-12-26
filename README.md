# Wordpress

Wordpress一键安装脚本。

## 使用方法
- sudo su root
- 编辑docker-compose.example.yml文件，设置mysql用户和密码。
- 编辑default.example.conf，这是nginx的配置文件，根据需要更改配置。
- bash deploy.sh
- 证书设置
  - export CF_Token="******"
  -	export CF_Account_ID="******"
  - acme.sh --issue --dns dns_cf -d *.example.com -d example.com
