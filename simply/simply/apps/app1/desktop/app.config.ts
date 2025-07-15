import { defineConfig } from "@solidjs/start/config"

export default defineConfig({
  server: {
    preset: "static",
  },
  vite: {
    server: {
      port: 1420,
    },
  },
})
