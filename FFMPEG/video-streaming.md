https://www.kurento.org/blog/rtp-ii-streaming-ffmpeg
https://stackoverflow.com/questions/16658873/how-to-minimize-the-delay-in-a-live-streaming-with-ffmpeg
https://trac.ffmpeg.org/wiki/StreamingGuide#Latency

probesize : https://www.ffmpeg.org/ffmpeg-formats.html

- Play video stream (may have delay):
```shell
ffplay -protocol_whitelist file,rtp,udp -i rp_video.sdp

```

- Play video stream (low delay):
```shell
ffplay -protocol_whitelist file,rtp,udp -fflags nobuffer -flags low_delay -framedrop -i rp_video.sdp

ffplay -protocol_whitelist file,rtp,udp -fflags nobuffer -flags low_delay -framedrop -probesize 32 -i rp_video.sdp

ffplay -protocol_whitelist file,rtp,udp -fflags nobuffer -flags low_delay -framedrop -threads 1 -i rp_video.sdp
```

- Play video stream (more lower delay):
```shell
ffplay -protocol_whitelist file,rtp,udp -fflags nobuffer -flags low_delay -framedrop -vf setpts=0 -i rp_video.sdp
```

- Play video stream (again more lower delay):
Starting delay is also reduced in this one thanks to `-probesize` and `analyzeduration` which reduce time analyzis used at sartup, useful when stream infos are needed (to calculate FPS), here we completely ignore them !
```shell
ffplay -protocol_whitelist file,rtp,udp -fflags nobuffer -flags low_delay -framedrop -vf setpts=0 -i -probesize 32 -analyzeduration 1 -i rp_video.sdp
```

Side note : 
`-sync` seems to reduce latency as well:
```shell
ffplay -probesize 32 -sync ext INPUT
```
> See here for more infos: https://ffmpeg.org/ffplay.html