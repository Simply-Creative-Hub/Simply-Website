import { createAsync } from "@solidjs/router"
import { Button } from "ui/Button"

async function fetchBackendData() {
  try {
    const response = await fetch("/api/hello")
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    return await response.json()
  } catch (error) {
    console.error("Error fetching data:", error)
    return { message: "Error connecting to backend", error: error.message }
  }
}

export default function Home() {
  const data = createAsync(() => fetchBackendData())

  return (
    <div class="space-y-6">
      <h1 class="text-3xl font-bold">Home Page</h1>
      <p class="text-lg">Welcome to App 1 Web Frontend (SolidStart)</p>

      <div class="p-4 bg-white rounded-lg shadow">
        <h2 class="text-xl font-semibold mb-2">Backend Response:</h2>
        <pre class="bg-gray-100 p-3 rounded text-sm overflow-auto">
          {JSON.stringify(data() || "Loading...", null, 2)}
        </pre>
      </div>

      <div class="space-x-4">
        <Button>Click Me</Button>
        <Button variant="secondary">Secondary</Button>
        <Button variant="outline">Outline</Button>
      </div>
    </div>
  )
}
