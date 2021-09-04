# handbrake
FROM jrottenberg/ffmpeg:4.4-nvidia2004 AS handbrake

RUN apt update && apt install -y \
    software-properties-common
    
RUN add-apt-repository ppa:stebbins/handbrake-releases && \
    apt update && \
    apt install -y handbrake-cli lsdvd

VOLUME /conf /workspace /ffmpeg1 /ffmpeg_output1 /ffmpeg2 /ffmpeg_output2 /ffmpeg3 /ffmpeg_output3 /handbrake1 /handbrake_output1 /handbrake2 /handbrake_output2 /handbrake3 /handbrake_output3
WORKDIR /workspace
COPY start.sh /workspace
COPY ffmpeg.sh /workspace
COPY handbrake.sh /workspace

ENTRYPOINT bash start.sh
