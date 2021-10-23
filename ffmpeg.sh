#!/bin/bash

#if [ $# != 4 ]; then
#    echo "Usage: encode.sh keepFile targetDir targetExt outputDir encodeOpt encodedLogFile"
#    exit 0
#fi

keepfile=${1:-1}
targetdir=${2:-`pwd`}
targetext=${3:-mp4}
outputdir=${4:-`pwd`}
encodedlog=${5:-`pwd`/encoded.log}
mheight=${6:-720}
mbitrate=${7:-1200000}
encodeopt=${8:-"-c:v h264_nvenc -movflags +faststart -map_metadata 0 -profile:v high -level:v 4.0 -b_strategy 2 -bf 2 -flags cgop -coder ac -pix_fmt yuv420p -crf 32 -bufsize 16M -c:a mp3 -ac 1 -ar 22050 -b:a 96k"}
destext=${9:-"mp4"}
mtime=${10:-"+0"}

count=1

while read -r file; do

 if [ -f `dirname "${encodedlog}"`"/encode_pause" ]; then
  echo "Encode has been paused. Please delete confdir's encode_pause if it will start"
  exit 0
 fi

 if [ -f "${file}" ]; then
  :
 else
  echo "file not found:${file}"
  continue
 fi
 
 filedir=`dirname "${file}"`

 if [ -f "${filedir}/encode-in-progress" ]; then
  echo "${filedir} is encoding by other process. next"
  continue
 else
  touch "${filedir}/encode-in-progress"
 fi

 checksum=`md5sum -b "${file}" | cut -d ' ' -f 1`

 `grep -q "${checksum}" ${encodedlog}`
 if [ 0 = $? ]; then
  echo "file has encoded before:${file}"
  rm -f "${filedir}/encode-in-progress"
  continue
 fi

 file_withoutext=`basename "${file%.*}"`
 
 destfile=${outputdir}/${file_withoutext}"."${destext}
 if [ -s "${destfile}" ]; then
  destfile=${outputdir}/${file_withoutext}"-"`date +%Y%m%d%H%M%S`"."${destext}
 fi

 bitrate=`ffprobe -show_entries format=bit_rate -v quiet -of csv="p=0" -i "${file}"`
 height_all=`ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=nw=1:nk=1 -i "${file}"`
 height=(${height_all// / })

 maxheight=`test ${height} -gt ${mheight} && echo ${mheight} || echo ${height}`
 maxbitrate=`test ${bitrate} -gt ${mbitrate} && echo ${mbitrate} || echo ${bitrate}`

 echo ${file}
 echo ${height} to ${maxheight}
 echo ${bitrate} to ${maxbitrate}
 
 echo ffmpeg -i "${file}" "${encodeopt}" -maxrate ${maxbitrate} -vf scale=-1:${maxheight} "${destfile}"
 ffmpeg -i "${file}" ${encodeopt} -maxrate ${maxbitrate} -vf scale=-1:${maxheight} "${destfile}"

 duration_base=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${file}"`
 duration_dest=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${destfile}"`

 duration_base_sec=(${duration_base//./ })
 duration_dest_sec=(${duration_dest//./ })

 if [ "${duration_base_sec}" != "${duration_dest_sec}" ]; then
  echo "encode uncompleted. delete fragment file:${destfile}"
  rm -f "${destfile}"
  rm -f "${filedir}/encode-in-progress"
  continue
 fi

 sync

 checksum_dest=`md5sum -b "${destfile}" | cut -d ' ' -f 1` 
 echo ${checksum}" "${file} >> ${encodedlog}
 echo ${checksum_dest}" "${destfile} >> ${encodedlog}

 echo "encode result"
 echo `ls -l "${file}"`
 echo `ls -l "${destfile}"`

 if [ 0 = ${keepfile} ]; then
  echo "delete original file:${file}"
  rm "${file}"
 fi

 if [ ! -s "${destfile}" ]; then
  echo "file is empty. deleted."
  rm -f "${destfile}"
 fi

 count=$((count+1))

 if [ $count -gt 10 ]; then
  rm -f "${filedir}/encode-in-progress"
  exit 0
 fi
 
 rm -f "${filedir}/encode-in-progress"
 
done <<< "$(find ${targetdir} -type f -mtime "$mtime" -regextype posix-egrep -regex "^.*?($targetext)$")"

