# handbrake
FROM jrottenberg/ffmpeg:4.4-nvidia2004 AS handbrake

ENV HANDBRAKE_URL_GIT https://github.com/HandBrake/HandBrake.git

RUN apt update && apt install -y \
    curl \
    diffutils \
    file \
    coreutils \
    m4 \
    xz-utils \
    nasm \
    python3 \
    python3-pip \
    appstream \
    autoconf \
    automake \
    autopoint \
    build-essential \
    cmake \
    git \
    libass-dev \
    libbz2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libfribidi-dev \
    libharfbuzz-dev \
    libjansson-dev \
    liblzma-dev \
    libmp3lame-dev \
    libnuma-dev \
    libogg-dev \
    libopus-dev \
    libsamplerate-dev \
    libspeex-dev \
    libtheora-dev \
    libtool \
    libtool-bin \
    libturbojpeg0-dev \
    libvorbis-dev \
    libx264-dev \
    libxml2-dev \
    libvpx-dev \
    m4 \
    make \
    meson \
    ninja-build \
    patch \
    pkg-config \
    tar \
    zlib1g-dev \
    libva-dev \
    libdrm-dev

WORKDIR /HB

RUN git clone $HANDBRAKE_URL_GIT

WORKDIR /HB/HandBrake

RUN pip3 install -U meson

RUN ./configure --prefix=/usr/local \
                --disable-gtk-update-checks \
                --disable-gtk \
                --enable-x265 \
                --enable-numa \
                --enable-nvenc \
                --enable-qsv \
                --launch-jobs=$(nproc) \
                --launch

RUN make -j$(nproc) --directory=build install

#base-image
FROM jrottenberg/ffmpeg:4.4-nvidia2004 AS base

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all
ENV DEBIAN_FRONTEND noninterac1tive

RUN apt update && apt install -y \
    libass-dev \
    libbz2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libfribidi-dev \
    libharfbuzz-dev \
    libjansson-dev \
    liblzma-dev \
    libmp3lame-dev \
    libnuma-dev \
    libogg-dev \
    libopus-dev \
    libsamplerate-dev \
    libspeex-dev \
    libtheora-dev \
    libtool \
    libtool-bin \
    libturbojpeg0-dev \
    libvorbis-dev \
    libx264-dev \
    libxml2-dev \
    libvpx-dev \
    libva-dev \
    libdrm-dev \
    lsdvd \
    lsscsi \
    bash 

RUN apt-get update && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    apt-get clean -y && \
    apt-get purge -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy HandBrake from base build image
COPY --from=handbrake /usr/local /usr

VOLUME /conf /watch1 /output1 /watch2 /output2 /watch3 /output3 /workspace
WORKDIR /workspace
COPY start.sh /workspace
COPY encode.sh /workspace

ENTRYPOINT bash start.sh
