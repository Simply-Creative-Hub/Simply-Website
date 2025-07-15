import { json } from "@solidjs/router"

export async function GET() {
  return json({
    message: "Hello from SolidStart API!",
    timestamp: new Date().toISOString(),
    status: "success",
    framework: "SolidStart",
  })
}
