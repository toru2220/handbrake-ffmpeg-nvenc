# handbrake
FROM jrottenberg/ffmpeg:5.1.2-nvidia2004 AS handbrake

RUN apt update && \
    apt install -y git lsdvd task-spooler autoconf automake autopoint appstream build-essential cmake git libass-dev libbz2-dev libfontconfig1-dev libfreetype6-dev libfribidi-dev libharfbuzz-dev libjansson-dev liblzma-dev libmp3lame-dev libnuma-dev libogg-dev libopus-dev libsamplerate-dev libspeex-dev libtheora-dev libtool libtool-bin libturbojpeg0-dev libvorbis-dev libx264-dev libxml2-dev libvpx-dev m4 make meson nasm ninja-build patch pkg-config tar zlib1g-dev clang

RUN git clone https://github.com/HandBrake/HandBrake.git && cd HandBrake && \
    ./configure --launch-jobs=$(nproc) --launch --disable-gtk && \
    make --directory=build install

VOLUME /conf /logs /workspace /ffmpeg-in-1 /ffmpeg-in-2 /ffmpeg-in-3 /ffmpeg-in-4 /ffmpeg-in-5 /ffmpeg-in-6 /ffmpeg-in-7 /ffmpeg-in-8 /ffmpeg-in-9 /ffmpeg-in-10 /ffmpeg-out-1 /ffmpeg-out-2 /ffmpeg-out-3 /ffmpeg-out-4 /ffmpeg-out-5 /ffmpeg-out-6 /ffmpeg-out-7 /ffmpeg-out-8 /ffmpeg-out-9 /ffmpeg-out-10 /handbrake-in-1 /handbrake-in-2 /handbrake-in-3 /handbrake-in-4 /handbrake-in-5 /handbrake-in-6 /handbrake-in-7 /handbrake-in-8 /handbrake-in-9 /handbrake-in-10 /handbrake-out-1 /handbrake-out-2 /handbrake-out-3 /handbrake-out-4 /handbrake-out-5 /handbrake-out-6 /handbrake-out-7 /handbrake-out-8 /handbrake-out-9 /handbrake-out-10

ENV TMPDIR=/logs

RUN mkdir -p /usr/local/bin /patched-lib
COPY patch.sh docker-entrypoint.sh start.sh ffmpeg.sh handbrake.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/patch.sh /usr/local/bin/ffmpeg.sh /usr/local/bin/handbrake.sh /usr/local/bin/start.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

