FROM centos
ARG SSH_KEY
ENV SSH_KEY=$SSH_KEY
RUN set -xe; \
    # update mirror
    sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*; \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*; \
    # install epel for qtwebkit
    dnf install -y wget; \
    wget https://download-ib01.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/e/epel-release-8-15.el8.noarch.rpm; \
    rpm -Uvh epel-release-8-15.el8.noarch.rpm; \
    rm epel-release-8-15.el8.noarch.rpm; \
    # install dependences
    dnf install -y openssh-clients gcc-toolset-10-gcc-c++ libatomic gcc-toolset-10-libatomic-devel git cmake qt5-qtwebkit qt5-qtwebkit-devel libarchive; \
    dnf install --enablerepo=powertools -y gflags gflags-devel sqlite sqlite-devel glog glog-devel python39-devel; \
    # if $SSH_KEY is empty, we will do git clone by https
    if [ -z "$SSH_KEY" ]; then \
        git config --global url.https://github.com/.insteadOf git@github.com:; \
    else \
        mkdir /root/.ssh/; \
        echo "$SSH_KEY" > /root/.ssh/id_rsa; \
        chmod 600 /root/.ssh/id_rsa; \
        touch /root/.ssh/known_hosts; \
        ssh-keyscan github.com >> /root/.ssh/known_hosts; \
    fi; \
    # clone project
    git clone git@github.com:slontia/lgtbot-mirai.git lgtbot-mirai-src; \
    cd lgtbot-mirai-src; \
    git submodule update --init --recursive mirai-cpp; \
    git submodule update --init --remote lgtbot; \
    cd lgtbot; \
    git submodule update --init --recursive; \
    cd ../../; \
    # compile
    source /opt/rh/gcc-toolset-10/enable; \
    cmake lgtbot-mirai-src -B lgtbot-mirai-release -DCMAKE_BUILD_TYPE=Release -DWITH_GCOV=OFF -DWITH_ASAN=OFF -DWITH_GLOG=OFF -DWITH_SQLITE=ON -DWITH_TEST=OFF -DWITH_SIMULATOR=ON -DWITH_GAMES=ON; \
    cd lgtbot-mirai-release; \
    make; \
    # move lgtbot files
    mkdir ../lgtbot-mirai; \
    mv lgtbot-mirai libbot_core.so markdown2image plugins score_updater simulator ../lgtbot-mirai; \
    cd ../; \
    # install chinese font
    wget https://github.com/adobe-fonts/source-han-serif/raw/release/Variable/TTF/SourceHanSerifSC-VF.ttf; \
    mkdir /usr/share/fonts/chinese; \
    mv SourceHanSerifSC-VF.ttf /usr/share/fonts/chinese; \
    fc-cache -f /usr/share/fonts; \
    # cleanup ssh
    rm -rf /root/.ssh/ lgtbot-mirai-src lgtbot-mirai-release; \
    dnf remove -y wget openssh-clients gcc-toolset-10-gcc-c++ gcc-toolset-10-libatomic-devel git cmake qt5-qtwebkit-devel gflags-devel sqlite-devel glog-devel; \

