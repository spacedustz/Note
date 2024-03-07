#!/bin/bash

for i in {1..30}; do
  j=$(printf "%02d" $i)
  mkdir -p "/home/space/hls/video/$j"

nohup ffmpeg -i rtsp://192.168.0.7:8554/$j -c:v copy -c:a copy -hls_time 2 -hls_list_size 6 -hls_flags delete_segments -hls_allow_cache 0 -fflags nobuffer -strict experimental -avioflags direct -fflags discardcorrupt -flags low_delay -segment_wrap 6 -start_number 1 /home/dains/hls/video/$j/output.m3u8 &
done
