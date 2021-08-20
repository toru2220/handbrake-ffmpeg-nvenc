#!/bin/sh

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
encodeopt=${8:-"-movflags +faststart -c:v h264_nvenc -profile:v high -level:v 4.0 -b_strategy 2 -bf 2 -flags cgop -coder ac -pix_fmt yuv420p -crf 32 -bufsize 16M -c:a mp3 -ac 1 -ar 22050 -b:a 96k"}

for file in ${targetdir}/*.${targetext}; do

 if [ -s "${file}" ]; then
  : 
 else
  echo "file not found:${file}"
  continue
 fi

 checksum=`md5sum -b "${file}" | cut -d ' ' -f 1`

 `grep -q "${checksum}" ${encodedlog}`
 if [ 0 = $? ]; then
  echo "file has encoded before:${file}"
  continue
 fi

 destfile=${outputdir}/`basename "${file}"`
 if [ -s "${destfile}" ]; then
  destfile=${outputdir}/`basename "${file}" .${targetext}`"-"`date +%Y%m%d%H%M%S`"."${targetext}
 fi

 bitrate=`ffprobe -show_entries format=bit_rate -v quiet -of csv="p=0" -i "${file}"`
 height=`ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=nw=1:nk=1 -i "${file}"`

 maxheight=`test ${height} -gt ${mheight} && echo ${mheight} || echo ${height}`
 maxbitrate=`test ${bitrate} -gt ${mbitrate} && echo ${mbitrate} || echo ${bitrate}`

 echo ${file}
 echo ${height} to ${maxheight}
 echo ${bitrate} to ${maxbitrate}

 ffmpeg -i "${file}" ${encodeopt} -maxrate ${maxbitrate} -vf scale=-1:${maxheight} "${destfile}"

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

done


