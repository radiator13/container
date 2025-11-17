FROM ubuntu:questing AS initial
WORKDIR /
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends git ca-certificates libarchive-tools curl && \
    #curl -L -o clang.tar.gz https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/ad834e67b1105d15ef907f6255d4c96e8e733f57/clang-r547379.tar.gz && \
    #mkdir -p /tc && tar -xzf clang.tar.gz -C /tc && rm clang.tar.gz && \
    curl -L -o tc.7z https://github.com/Mandi-Sa/clang/releases/download/amd64-kernel-arm_static-22/llvm22.0.0-binutils2.44_amd64-kernel-arm_static-20251116.7z && \
    mkdir tc && bsdtar -xf tc.7z -C tc && rm tc.7z &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*

FROM ubuntu:questing
WORKDIR /build
COPY --from=initial /tc /build/tc
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    apt-get install -y --no-install-recommends sed sudo cpio curl tar zstd libssl-dev openssl libxml2-16 libxml2-utils libxml2-dev \
    which bc gawk perl diffutils locales make python3 xz-utils bison flex git unzip ca-certificates libc6-dev libgcc-14-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/lib/apt/archives/* /usr/share/man/* && \
    echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "LANG=en_US.UTF-8" >> /etc/locale.conf && \
    locale-gen en_US.UTF-8
    
ENV PATH="$PATH:/build/tc/bin"
