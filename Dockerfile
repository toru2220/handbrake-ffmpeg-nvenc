# handbrake
FROM jrottenberg/ffmpeg:4.4-nvidia2004 AS handbrake

RUN apt update && apt install -y \
    software-properties-common
    
RUN add-apt-repository ppa:stebbins/handbrake-releases && \
    apt update && \
    apt install -y handbrake-cli lsdvd task-spooler

VOLUME /conf /logs /workspace /ffmpeg_in_1 /ffmpeg_in_2 /ffmpeg_in_3 /ffmpeg_in_4 /ffmpeg_in_5 /ffmpeg_in_6 /ffmpeg_in_7 /ffmpeg_in_8 /ffmpeg_in_9 /ffmpeg_in_10 /ffmpeg_out_1 /ffmpeg_out_2 /ffmpeg_out_3 /ffmpeg_out_4 /ffmpeg_out_5 /ffmpeg_out_6 /ffmpeg_out_7 /ffmpeg_out_8 /ffmpeg_out_9 /ffmpeg_out_10 /handbrake_in_1 /handbrake_in_2 /handbrake_in_3 /handbrake_in_4 /handbrake_in_5 /handbrake_in_6 /handbrake_in_7 /handbrake_in_8 /handbrake_in_9 /handbrake_in_10 /handbrake_out_1 /handbrake_out_2 /handbrake_out_3 /handbrake_out_4 /handbrake_out_5 /handbrake_out_6 /handbrake_out_7 /handbrake_out_8 /handbrake_out_9 /handbrake_out_10
WORKDIR /workspace
COPY start.sh /workspace
COPY ffmpeg.sh /workspace
COPY handbrake.sh /workspace

ENV TMPDIR=/logs
ENTRYPOINT bash start.sh
