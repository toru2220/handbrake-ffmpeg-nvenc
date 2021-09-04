#!/bin/sh

keepfile_ffmpeg=${FFMPEG_KEEP_FILE:-1}
encodedlog=${ENCODED_LOG:-"/conf"}

targetext_ffmpeg1=${FFMPEG_TARGET_EXT_1:-mp4}
maxheight_ffmpeg1=${FFMPEG_MAX_HEIGHT_1:-720}
maxbitrate_ffmpeg1=${FFMPEG_MAX_BITRATE_1:-1200000}

encodeopt_ffmpeg1=${FFMPEG_ENCODE_OPT_1:-"-movflags +faststart -c:v h264_nvenc -profile:v high -level:v 4.0 -b_strategy 2 -bf 2 -flags cgop -coder ac -pix_fmt yuv420p -crf 32 -bufsize 16M -c:a mp3 -ac 1 -ar 22050 -b:a 96k"}

targetext_ffmpeg2=${FFMPEG_TARGET_EXT_2:-mp4}
maxheight_ffmpeg2=${FFMPEG_MAX_HEIGHT_2:-720}
maxbitrate_ffmpeg2=${FFMPEG_MAX_BITRATE_2:-1200000}

encodeopt_ffmpeg2=${FFMPEG_ENCODE_OPT_2:-"-movflags +faststart -c:v h264_nvenc -profile:v high -level:v 4.0 -b_strategy 2 -bf 2 -flags cgop -coder ac -pix_fmt yuv420p -crf 32 -bufsize 16M -c:a mp3 -ac 1 -ar 22050 -b:a 96k"}

targetext_ffmpeg3=${FFMPEG_TARGET_EXT_3:-mp4}
maxheight_ffmpeg3=${FFMPEG_MAX_HEIGHT_3:-720}
maxbitrate_ffmpeg3=${FFMPEG_MAX_BITRATE_3:-1200000}

encodeopt_ffmpeg3=${FFMPEG_ENCODE_OPT_3:-"-movflags +faststart -c:v h264_nvenc -profile:v high -level:v 4.0 -b_strategy 2 -bf 2 -flags cgop -coder ac -pix_fmt yuv420p -crf 32 -bufsize 16M -c:a mp3 -ac 1 -ar 22050 -b:a 96k"}

keepfile_handbrake=${HANDBRAKE_KEEP_FILE:-1}

targetext_handbrake1=${HANDBRAKE_TARGET_EXT_1:-ISO}
maxheight_handbrake1=${HANDBRAKE_MAX_HEIGHT_1:-1280}
maxbitrate_handbrake1=${HANDBRAKE_MAX_BITRATE_1:-2000}

encodeopt_handbrake1=${HANDBRAKE_ENCODE_OPT_1:-"-e nvenc_h264 -r 29.97 --pfr -E faac -B 160 -6 dpl2 -R Auto -D 0.0 -f mp4 --crop 0:0:0:0 --loose-anamorphic -m --decomb -x cabac=0:ref=2:me=umh:bframes=0:weightp=0:subme=6:8x8dct=0:trellis=0 -O --all-audio --all-subtitles"}

targetext_handbrake2=${HANDBRAKE_TARGET_EXT_2:-ISO}
maxheight_handbrake2=${HANDBRAKE_MAX_HEIGHT_2:-1280}
maxbitrate_handbrake2=${HANDBRAKE_MAX_BITRATE_2:-2000}

encodeopt_handbrake2=${HANDBRAKE_ENCODE_OPT_2:-"-e nvenc_h264 -r 29.97 --pfr -E faac -B 160 -6 dpl2 -R Auto -D 0.0 -f mp4 --crop 0:0:0:0 --loose-anamorphic -m --decomb -x cabac=0:ref=2:me=umh:bframes=0:weightp=0:subme=6:8x8dct=0:trellis=0 -O --all-audio --all-subtitles"}

targetext_handbrake3=${HANDBRAKE_TARGET_EXT_3:-ISO}
maxheight_handbrake3=${HANDBRAKE_MAX_HEIGHT_3:-1280}
maxbitrate_handbrake3=${HANDBRAKE_MAX_BITRATE_3:-2000}

encodeopt_handbrake3=${HANDBRAKE_ENCODE_OPT_3:-"-e nvenc_h264 -r 29.97 --pfr -E faac -B 160 -6 dpl2 -R Auto -D 0.0 -f mp4 --crop 0:0:0:0 --loose-anamorphic -m --decomb -x cabac=0:ref=2:me=umh:bframes=0:weightp=0:subme=6:8x8dct=0:trellis=0 -O --all-audio --all-subtitles"}


while true
do

 echo "encoded start[1]: ${keepfile_handbrake} ${targetext_handbrake1} ${encodedlog} ${maxheight_handbrake1} ${maxbitrate_handbrake1} ${encodeopt_handbrake1}"

 ./handbrake.sh ${keepfile_handbrake} /handbrake1 ${targetext_handbrake1} /handbrake_output1 "${encodedlog}/encoded.log" ${maxheight_handbrake1} ${maxbitrate_handbrake1} "${encodeopt_handbrake1}"

 echo "encoded start[2]: ${keepfile_handbrake} ${targetext_handbrake2} ${encodedlog} ${maxheight_handbrake2} ${maxbitrate_handbrake2} ${encodeopt_handbrake2}"

 ./handbrake.sh ${keepfile_handbrake} /handbrake2 ${targetext_handbrake2} /handbrake_output2 "${encodedlog}/encoded.log" ${maxheight_handbrake2} ${maxbitrate_handbrake2} "${encodeopt_handbrake2}"

 echo "encoded start[3]: ${keepfile_handbrake} ${targetext_handbrake3} ${encodedlog} ${maxheight_handbrake3} ${maxbitrate_handbrake3} ${encodeopt_handbrake3}"

 ./handbrake.sh ${keepfile_handbrake} /handbrake3 ${targetext_handbrake3} /handbrake_output3 "${encodedlog}/encoded.log" ${maxheight_handbrake3} ${maxbitrate_handbrake3} "${encodeopt_handbrake3}"

 echo "encoded start[1]: ${keepfile_ffmpeg} ${targetext_ffmpeg1} ${encodedlog} ${maxheight_ffmpeg1} ${maxbitrate_ffmpeg1} ${encodeopt_ffmpeg1}"

 ./ffmpeg.sh ${keepfile_ffmpeg} /ffmpeg1 ${targetext_ffmpeg1} /ffmpeg_output1 "${encodedlog}/encoded.log" ${maxheight_ffmpeg1} ${maxbitrate_ffmpeg1} "${encodeopt_ffmpeg1}"

 echo "encoded start[2]: ${keepfile_ffmpeg} ${targetext_ffmpeg2} ${encodedlog} ${maxheight_ffmpeg2} ${maxbitrate_ffmpeg2} ${encodeopt_ffmpeg2}"

 ./ffmpeg.sh ${keepfile_ffmpeg} /ffmpeg2 ${targetext_ffmpeg2} /ffmpeg_output2 "${encodedlog}/encoded.log" ${maxheight_ffmpeg2} ${maxbitrate_ffmpeg2} "${encodeopt_ffmpeg2}"

 echo "encoded start[3]: ${keepfile_ffmpeg} ${targetext_ffmpeg3} ${encodedlog} ${maxheight_ffmpeg3} ${maxbitrate_ffmpeg3} ${encodeopt_ffmpeg3}"

 ./ffmpeg.sh ${keepfile_ffmpeg} /ffmpeg3 ${targetext_ffmpeg3} /ffmpeg_output3 "${encodedlog}/encoded.log" ${maxheight_ffmpeg3} ${maxbitrate_ffmpeg3} "${encodeopt_ffmpeg3}"

 echo "encode finished. wait 60 seconds..."
 sleep 60
 
done
