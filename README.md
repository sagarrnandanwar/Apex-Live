# Camera Detection and Streaming

This README provides instructions for detecting a camera, running the camera feed, and performing HLS encoding using FFmpeg.

## 1. Detect Camera

To detect available cameras on your system, use the following command:

```bash
ffmpeg -list_devices true -f dshow -i dummy
```

This command will list all the devices (cameras) connected to your computer.

## 2. Run Camera

To run the camera and stream the feed, execute the following command:

```bash
ffmpeg -f dshow -i video="Camera Name" -c:v libx264 -preset ultrafast -f flv rtmp://localhost:1935/live/webcam
```

Replace `"Camera Name"` with the actual name of your camera as listed in the previous step. This command will encode the video using the H.264 codec and stream it to an RTMP server.

## 3. Run HLS Encoding

To encode the video stream into HLS format, use the following command:

```bash
ffmpeg -i rtmp://localhost:1935/live/webcam -c:v libx264 -f hls C:\Projects\Apex-Live\backend\media\live\stream.m3u8
```

This command will read the RTMP stream and create an HLS playlist file and associated segment files in the specified directory.

## Important Notes

- **File Security**: Ensure to disable file security features that might prevent FFmpeg from accessing necessary files.
- **Absolute File Paths**: Always use absolute file paths in your commands to avoid issues with file access.
