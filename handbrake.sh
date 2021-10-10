#!/bin/sh

#if [ $# != 4 ]; then
#    echo "Usage: encode.sh keepFile targetDir targetExt outputDir encodeOpt encodedLogFile"
#    exit 0
#fi

keepfile=${1:-1}
targetdir=${2:-`pwd`}
targetext=${3:-ISO}
outputdir=${4:-`pwd`}
encodedlog=${5:-`pwd`/encoded.log}
mheight=${6:-1280}
mbitrate=${7:-2000}
encodeopt=${8:-"-e nvenc_h264 -r 29.97 --pfr -E faac -B 160 -6 dpl2 -R Auto -D 0.0 -f mp4 --crop 0:0:0:0 --loose-anamorphic -m --decomb -x cabac=0:ref=2:me=umh:bframes=0:weightp=0:subme=6:8x8dct=0:trellis=0 -O --all-audio --all-subtitles"}
destext=${9:-mp4}

count=1
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
 
 for titleid in $(seq 1 `lsdvd -q "${file}" | grep -c "^Title:"`); do 

  destfile=${outputdir}/`basename "${file}" .${targetext}`"-"${titleid}"."${destext}
  if [ -s "${destfile}" ]; then
   destfile=${outputdir}/`basename "${file}" .${targetext}`"-"${titleid}"-"`date +%Y%m%d%H%M%S`"."${destext}
  fi
  
  echo HandBrakeCLI -i "${file}" -t ${titleid} -b ${mbitrate} -X ${mheight} ${encodeopt} -o "${destfile}"
  time HandBrakeCLI -i "${file}" -t ${titleid} -b ${mbitrate} -X ${mheight} ${encodeopt} -o "${destfile}"

 done
 
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

 count=$((count+1))

 if [ $count -gt 10 ]; then
  return 0
 fi
 
done
