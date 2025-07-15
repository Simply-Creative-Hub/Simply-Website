import { createResource } from "solid-js"
import { Button } from "ui/Button"

export function Home() {
  const [data] = createResource(async () => {
    try {
      const response = await fetch("/api/hello")
      return await response.json()
    } catch (error) {
      console.error("Error fetching data:", error)
      return { message: "Error connecting to backend" }
    }
  })

  return (
    <div class="space-y-6">
      <h1 class="text-3xl font-bold">Home Page</h1>
      <p class="text-lg">Welcome to App 1 Web Frontend</p>

      <div class="p-4 bg-white rounded-lg shadow">
        <h2 class="text-xl font-semibold mb-2">Backend Response:</h2>
        <pre class="bg-gray-100 p-3 rounded">{JSON.stringify(data() || "Loading...", null, 2)}</pre>
      </div>

      <Button>Click Me</Button>
    </div>
  )
}
