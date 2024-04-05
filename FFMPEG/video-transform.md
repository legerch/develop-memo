_in construction_

# Cropping

https://video.stackexchange.com/questions/4563/how-can-i-crop-a-video-with-ffmpeg
https://superuser.com/questions/624563/how-to-resize-a-video-to-make-it-smaller-with-ffmpeg
https://linuxhint.com/crop_videos_linux/

# Cutting

https://shotstack.io/learn/use-ffmpeg-to-trim-video/
https://stackoverflow.com/questions/18444194/cutting-the-videos-based-on-start-and-end-time-using-ffmpeg
https://superuser.com/questions/138331/using-ffmpeg-to-cut-up-video

Command to cut from start and keep only `5` seconds :
```shell
ffmpeg -ss 0 -t 5 -i intro.mp4 -c copy intro-cut.mp4
```

3840x2160 -> 1920x1080 :
ffmpeg -i input.mp4 -s 1920x1080 -c:a copy output.mp4

1920x1080 -> 1080x1080 :
ffmpeg -i output.mp4 -filter:v "crop=1080:1080:420:0" output-square.mp4

1080x1080 -> 128x128 :
ffmpeg -i output-square.mp4 -s 128x128 -c:a copy output-squares-128.mp4

https://superuser.com/questions/624563/how-to-resize-a-video-to-make-it-smaller-with-ffmpeg

# Create from image
## Single image

https://stackoverflow.com/questions/25891342/creating-a-video-from-a-single-image-for-a-specific-duration-in-ffmpeg

```shell
ffmpeg -loop 1 -i image.png -t 5 out.mp4
ffmpeg -loop 1 -i image.png -t 5 -c:v libx264 -framerate 25 -pix_fmt yuv420p out2.mp4
```

## Multiple images

https://stackoverflow.com/questions/24961127/how-to-create-a-video-from-images-with-ffmpeg
