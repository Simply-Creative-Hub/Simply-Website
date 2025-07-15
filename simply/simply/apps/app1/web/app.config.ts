import { defineConfig } from "@solidjs/start/config"

export default defineConfig({
  server: {
    preset: "node-server",
    experimental: {
      websocket: true,
    },
  },
  vite: {
    server: {
      proxy: {
        "/api": {
          target: "http://localhost:8000",
          changeOrigin: true,
        },
      },
    },
  },
})
