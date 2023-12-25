# handbrake
FROM jrottenberg/ffmpeg:5.1.2-nvidia2004 AS handbrake

RUN apt update && \
    apt install -y git lsdvd task-spooler autoconf automake autopoint appstream build-essential cmake git libass-dev libbz2-dev libfontconfig1-dev libfreetype6-dev libfribidi-dev libharfbuzz-dev libjansson-dev liblzma-dev libmp3lame-dev libnuma-dev libogg-dev libopus-dev libsamplerate-dev libspeex-dev libtheora-dev libtool libtool-bin libturbojpeg0-dev libvorbis-dev libx264-dev libxml2-dev libvpx-dev m4 make meson nasm ninja-build patch pkg-config tar zlib1g-dev clang

WORKDIR /tmp

RUN git clone https://github.com/HandBrake/HandBrake.git && cd HandBrake && \
    ./configure --launch-jobs=$(nproc) --launch --disable-gtk && \
    make --directory=build install

RUN mkdir -p /usr/local/bin /patched-lib
COPY patch.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/patch.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
