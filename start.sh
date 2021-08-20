#!/bin/sh

keepfile=${FFMPEG_KEEP_FILE:-1}
encodedlog=${FFMPEG_ENCODED_LOG:-"/conf"}

targetext1=${FFMPEG_TARGET_EXT_1:-mp4}
maxheight1=${FFMPEG_MAX_HEIGHT_1:-720}
maxbitrate1=${FFMPEG_MAX_BITRATE_1:-1200000}

encodeopt1=${FFMPEG_ENCODE_OPT_1:-"-movflags +faststart -c:v h264_nvenc -profile:v high -level:v 4.0 -b_strategy 2 -bf 2 -flags cgop -coder ac -pix_fmt yuv420p -crf 32 -bufsize 16M -c:a mp3 -ac 1 -ar 22050 -b:a 96k"}

targetext2=${FFMPEG_TARGET_EXT_2:-mp4}
maxheight2=${FFMPEG_MAX_HEIGHT_2:-720}
maxbitrate2=${FFMPEG_MAX_BITRATE_2:-1200000}

encodeopt2=${FFMPEG_ENCODE_OPT_2:-"-movflags +faststart -c:v h264_nvenc -profile:v high -level:v 4.0 -b_strategy 2 -bf 2 -flags cgop -coder ac -pix_fmt yuv420p -crf 32 -bufsize 16M -c:a mp3 -ac 1 -ar 22050 -b:a 96k"}

targetext3=${FFMPEG_TARGET_EXT_3:-mp4}
maxheight3=${FFMPEG_MAX_HEIGHT_3:-720}
maxbitrate3=${FFMPEG_MAX_BITRATE_3:-1200000}

encodeopt3=${FFMPEG_ENCODE_OPT_3:-"-movflags +faststart -c:v h264_nvenc -profile:v high -level:v 4.0 -b_strategy 2 -bf 2 -flags cgop -coder ac -pix_fmt yuv420p -crf 32 -bufsize 16M -c:a mp3 -ac 1 -ar 22050 -b:a 96k"}


while true
do

 echo "encoded start[1]: ${keepfile} ${targetdir1} ${targetext1} ${outputdir1} ${encodedlog} ${maxheight1} ${maxbitrate1} ${encodeopt1}"

 ./encode.sh ${keepfile} /watch1 ${targetext1} /output1 "${encodedlog}/encoded.log" ${maxheight1} ${maxbitrate1} "${encodeopt1}"

 echo "encoded start[2]: ${keepfile} ${targetdir2} ${targetext2} ${outputdir2} ${encodedlog} ${maxheight2} ${maxbitrate2} ${encodeopt2}"

 ./encode.sh ${keepfile} /watch2 ${targetext2} /output2 "${encodedlog}/encoded.log" ${maxheight2} ${maxbitrate2} "${encodeopt2}"

 echo "encoded start[3]: ${keepfile} ${targetdir3} ${targetext3} ${outputdir3} ${encodedlog} ${maxheight3} ${maxbitrate3} ${encodeopt3}"

 ./encode.sh ${keepfile} /watch3 ${targetext3} /output3 "${encodedlog}/encoded.log" ${maxheight3} ${maxbitrate3} "${encodeopt3}"

 echo "encode finished. wait 60 seconds..."
 sleep 60
done




