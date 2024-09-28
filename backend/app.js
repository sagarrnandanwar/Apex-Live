const NodeMediaServer = require("node-media-server");
const express = require("express");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 3000; // Port for Express

// Node Media Server configuration
const httpConfig = {
  port: 8000,
  allow_origin: "*",
  mediaroot: "./media/live",
};

const rtmpConfig = {
  port: 1935,
  chunk_size: 60000,
  gop_cache: true,
  ping: 10,
  ping_timeout: 60,
};

const transformationConfig = {
  ffmpeg: './ffmpeg/ffmpeg.exe', // Make sure this points to your FFmpeg installation
  tasks: [
    {
      app: 'live',
      hls: true, // Enable HLS
      hlsFlags: '[hls_time=5:hls_list_size=3]',
      hlsPath: './media/live', // Path for HLS files
      hlsCleanup: true, // Enables automatic cleanup
    },
  ]

};

const config = {
  http: httpConfig,
  rtmp: rtmpConfig,
  trans: transformationConfig,
};

// Serve the index.html file
app.use(express.static(path.join(__dirname)));

// Route for the homepage to serve index.html
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "index.html"), (err) => {
    if (err) {
      res.status(err.status).end();
    }
  });
});

// Start the Express server
app.listen(PORT, () => {
  console.log(`Express server is running on http://localhost:${PORT}`);
});

// Start the Node Media Server
const nms = new NodeMediaServer(config);
nms.run();
