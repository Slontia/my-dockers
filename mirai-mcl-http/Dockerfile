FROM centos
RUN set -xe; \
    # update mirror
    sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*; \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*; \
    # install mcl
    dnf install -y wget zip; \
    mkdir mcl; \
    cd mcl; \
    wget https://github.com/iTXTech/mirai-console-loader/releases/download/v2.1.0/mcl-2.1.0.zip; \
    unzip mcl-2.1.0.zip; \
    rm mcl-2.1.0.zip; \
    chmod +x mcl; \
    # download mirai-http
    mkdir plugins; \
    wget https://github.com/project-mirai/mirai-api-http/releases/download/v2.5.2/mirai-api-http-v2.5.2.mirai2.jar; \
    mkdir -p config/net.mamoe.mirai-api-http/;
COPY setting.yml config/net.mamoe.mirai-api-http/
