const NodeMediaServer = require("node-media-server");
const path = require("path");

const config = {
  rtmp: {
    port: 1935,
    chunk_size: 60000,
    gop_cache: true,
    ping: 30,
    ping_timeout: 60,
  },
  http: {
    port: 8000,
    allow_origin: "*",
    mediaroot: path.resolve(__dirname, "media"), // Ensure media is in the correct folder
  },
};

const nms = new NodeMediaServer(config);
nms.run();
