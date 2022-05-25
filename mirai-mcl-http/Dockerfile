FROM centos
RUN set -xe; \
    # update mirror
    sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*; \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*; \
    # install mcl
    dnf install -y wget zip java-11-openjdk vim; \
    mkdir mcl; \
    cd mcl; \
    wget https://github.com/iTXTech/mirai-console-loader/releases/download/v2.1.0/mcl-2.1.0.zip; \
    unzip mcl-2.1.0.zip; \
    rm mcl-2.1.0.zip; \
    chmod +x mcl; \
    # download mirai-http
    mkdir plugins; \
    cd plugins; \
    wget https://github.com/project-mirai/mirai-api-http/releases/download/v2.5.2/mirai-api-http-v2.5.2.mirai2.jar; \
    mkdir -p config/net.mamoe.mirai-api-http/; \
    # run mcl to update packages
    cd ..; \
    echo "exit" | ./mcl;
COPY setting.yml /mcl/config/net.mamoe.mirai-api-http/
WORKDIR /mcl
# update auth key after first boot mcl
ENTRYPOINT sed -i "s/1234567890/$(date +%s%N | md5sum | cut -c 1-9)/" /mcl/config/net.mamoe.mirai-api-http/setting.yml && vim /mcl/config/net.mamoe.mirai-api-http/setting.yml && ./mcl
