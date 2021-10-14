#!/bin/bash

find /*-in-* -type f -name "encode-in-progress" -exec rm "{}" \;

max_concurrent=${MAX_CONCURRENT:-1}
tsp -S $max_concurrent

ENCODED_LOG=/conf

FFMPEG_ENCODE_OPT_DEFAULT="-movflags +faststart -map_metadata 0 -c:v h264_nvenc -profile:v high -level:v 4.0 -b_strategy 2 -bf 2 -flags cgop -coder ac -pix_fmt yuv420p -crf 32 -bufsize 16M -c:a mp3 -ac 1 -ar 22050 -b:a 96k"
FFMPEG_KEEP_FILE_DEFAULT=1
FFMPEG_TARGET_EXT_DEFAULT=mp4
FFMPEG_MAX_HEIGHT_DEFAULT=720
FFMPEG_MAX_BITRATE_DEFAULT=1200000

HANDBRAKE_ENCODE_OPT_DEFAULT="-e nvenc_h264 -r 29.97 --pfr -E faac -B 160 -6 dpl2 -R Auto -D 0.0 -f mp4 --crop 0:0:0:0 --loose-anamorphic -m --decomb -x cabac=0:ref=2:me=umh:bframes=0:weightp=0:subme=6:8x8dct=0:trellis=0 -O --all-audio --all-subtitles"
HANDBRAKE_KEEP_FILE_DEFAULT=1
HANDBRAKE_TARGET_EXT_DEFAULT=ISO
HANDBRAKE_MAX_HEIGHT_DEFAULT=1280
HANDBRAKE_MAX_BITRATE_DEFAULT=2000

while true
do
 for i in $(seq 1 10); do
  var_name_ffmpeg_encode_opt="ffmpeg_encode_opt_${i}"
  var_name_ffmpeg_keep_file="ffmpeg_keep_file_${i}"
  var_name_ffmpeg_target_ext="ffmpeg_target_ext_${i}"
  var_name_ffmpeg_max_height="ffmpeg_max_height_${i}"
  var_name_ffmpeg_max_bitrate="ffmpeg_max_bitrate_${i}"
  ffmpeg_in="/ffmpeg-in-"${i}
  ffmpeg_out="/ffmpeg-out-"${i}

  var_name_handbrake_encode_opt="handbrake_encode_opt_${i}"
  var_name_handbrake_keep_file="handbrake_keep_file_${i}"
  var_name_handbrake_target_ext="handbrake_target_ext_${i}"
  var_name_handbrake_max_height="handbrake_max_height_${i}"
  var_name_handbrake_max_bitrate="handbrake_max_bitrate_${i}"
  handbrake_in="/handbrake-in-"${i}
  handbrake_out="/handbrake-out-"${i}

  eval "ffmpeg_encode_opt_${i}=\"\${FFMPEG_ENCODE_OPT_$i:-\$FFMPEG_ENCODE_OPT_DEFAULT}\""
  eval "ffmpeg_keep_file_${i}=\"\${FFMPEG_KEEP_FILE_$i:-\$FFMPEG_KEEP_FILE_DEFAULT}\""
  eval "ffmpeg_target_ext_${i}=\"\${FFMPEG_TARGET_EXT_$i:-\$FFMPEG_TARGET_EXT_DEFAULT}\""
  eval "ffmpeg_max_height_${i}=\"\${FFMPEG_MAX_HEIGHT_$i:-\$FFMPEG_MAX_HEIGHT_DEFAULT}\""
  eval "ffmpeg_max_bitrate_${i}=\"\${FFMPEG_MAX_BITRATE_$i:-\$FFMPEG_MAX_BITRATE_DEFAULT}\""

  eval "handbrake_encode_opt_${i}=\"\${HANDBRAKE_ENCODE_OPT_$i:-\$HANDBRAKE_ENCODE_OPT_DEFAULT}\""
  eval "handbrake_keep_file_${i}=\"\${HANDBRAKE_KEEP_FILE_$i:-\$HANDBRAKE_KEEP_FILE_DEFAULT}\""
  eval "handbrake_target_ext_${i}=\"\${HANDBRAKE_TARGET_EXT_$i:-\$HANDBRAKE_TARGET_EXT_DEFAULT}\""
  eval "handbrake_max_height_${i}=\"\${HANDBRAKE_MAX_HEIGHT_$i:-\$HANDBRAKE_MAX_HEIGHT_DEFAULT}\""
  eval "handbrake_max_bitrate_${i}=\"\${HANDBRAKE_MAX_BITRATE_$i:-\$HANDBRAKE_MAX_BITRATE_DEFAULT}\""

  if [ `tsp -l | grep -E queued\|running | wc -l` -lt 20 ] ; then
   JOBID=`tsp -n ./handbrake.sh ${!var_name_handbrake_keep_file} ${handbrake_in} ${!var_name_handbrake_target_ext} ${handbrake_out} "${ENCODED_LOG}/encoded.log" ${!var_name_handbrake_max_height} ${!var_name_handbrake_max_bitrate} "${!var_name_handbrake_encode_opt}"`
   echo "----- task-spooler job:${JOBID} details -----"
   tsp -i $JOBID
   JOBID=`tsp -n ./ffmpeg.sh ${!var_name_ffmpeg_keep_file} ${ffmpeg_in} ${!var_name_ffmpeg_target_ext} ${ffmpeg_out} "${ENCODED_LOG}/encoded.log" ${!var_name_ffmpeg_max_height} ${!var_name_ffmpeg_max_bitrate} "${!var_name_ffmpeg_encode_opt}"`
   echo "----- task-spooler job:${JOBID} details -----"
   tsp -i $JOBID
  else
   echo "task spooler queue is over 20"
  fi

 done
 
 sleep 120
done
