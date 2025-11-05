FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    git git-lfs ssh make gcc libssl-dev liblz4-tool expect g++ patchelf chrpath gawk texinfo \
    diffstat software-properties-common bison flex fakeroot cmake gcc-multilib \
    g++-multilib unzip device-tree-compiler libncurses-dev python3-pip file \
    python3-pyelftools bc build-essential zlib1g-dev libbz2-dev libreadline-dev \
    libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev \
    libxmlsec1-dev libffi-dev liblzma-dev uuid-dev libbluetooth-dev u-boot-tools \
    rsync libmpc-dev bsdmainutils python2 gettext qemu-user-static binfmt-support \
    live-build xxd sudo time \
    && rm -rf /var/lib/apt/lists/* && git lfs install

RUN update-binfmts --enable qemu-aarch64

# rebuild live-build
RUN bash -c '\
    apt-get remove -y live-build && \
    pushd /tmp && \
    git clone https://salsa.debian.org/live-team/live-build.git --depth 1 -b debian/1%20230131 && \
    cd live-build && \
    rm -rf manpages/po/ && \
    make install && \
    popd \
'

RUN ln -snf /usr/bin/python3 /usr/bin/python

CMD ["/bin/bash"]
