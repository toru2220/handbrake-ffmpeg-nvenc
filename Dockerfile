# handbrake
FROM jrottenberg/ffmpeg:4.4-nvidia2004 AS handbrake

RUN apt update && apt install -y \
    software-properties-common
    
RUN add-apt-repository ppa:stebbins/handbrake-releases && \
    apt update && \
    apt install -y handbrake-cli

VOLUME /conf /watch1 /output1 /watch2 /output2 /watch3 /output3 /workspace
WORKDIR /workspace
COPY start.sh /workspace
COPY encode.sh /workspace

ENTRYPOINT bash start.sh
