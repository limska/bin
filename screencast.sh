#!/bin/sh

echo Phase 1

# use xwininfo
Width=1920
Height=1150
AUpperLeftX=0
AUpperLeftY=49



# for ffmpeg 0.65
#ffmpeg -f x11grab -r 10 -s 1538x960 -i :0.0+169,119 -vcodec libx264 -vpre lossless_ultrafast -threads 0 $1.mkv
ffmpeg -framerate 10 -video_size ${Width}x${Height} -f x11grab -i :0.0+${AUpperLeftX},${AUpperLeftY} -vcodec libx264 -crf 0 -preset ultrafast $1.mkv

echo Phase 2

# for ffmpeg 0.65
#ffmpeg -i $1.mkv -vcodec libx264 -vpre hq -crf 22 -threads 10 $1.mp4
#ffmpeg -i $1.mkv -vcodec libx264 -crf 22 -threads 10 $1.mp4
ffmpeg -i $1.mkv -an -profile:v high -c:v libx264 -pix_fmt yuv420p $1.mp4

rm -v $1.mkv
