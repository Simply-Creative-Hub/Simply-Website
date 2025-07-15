"use client"

import { createSignal } from "solid-js"
import { invoke } from "@tauri-apps/api/tauri"
import { Button } from "ui/Button"

export default function Home() {
  const [name, setName] = createSignal("")
  const [greetMsg, setGreetMsg] = createSignal("")
  const [backendData, setBackendData] = createSignal<any>(null)
  const [loading, setLoading] = createSignal(false)
  const [error, setError] = createSignal<string | null>(null)

  async function greet() {
    setGreetMsg(await invoke("greet", { name: name() }))
  }

  async function fetchFromBackend() {
    setLoading(true)
    setError(null)
    try {
      const response = await invoke("call_backend", { endpoint: "/api/hello" })
      setBackendData(JSON.parse(response as string))
    } catch (err) {
      setError(`Error: ${err}`)
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div class="space-y-6">
      <h1 class="text-3xl font-bold">Home Page</h1>
      <p class="text-lg">Welcome to App 1 Desktop Frontend (SolidStart + Tauri)</p>

      <div class="p-4 bg-white rounded-lg shadow">
        <h2 class="text-xl font-semibold mb-4">Tauri Greet Function:</h2>
        <div class="space-y-2">
          <input
            class="border p-2 rounded w-full"
            value={name()}
            onInput={(e) => setName(e.currentTarget.value)}
            placeholder="Enter a name..."
          />
          <Button onClick={greet}>Greet</Button>
        </div>
        {greetMsg() && <p class="mt-2 p-2 bg-green-100 text-green-700 rounded">{greetMsg()}</p>}
      </div>

      <div class="p-4 bg-white rounded-lg shadow">
        <h2 class="text-xl font-semibold mb-2">Backend Communication:</h2>
        <Button onClick={fetchFromBackend} disabled={loading()}>
          {loading() ? "Loading..." : "Fetch from Backend"}
        </Button>

        {error() && <div class="mt-2 p-2 bg-red-100 text-red-700 rounded">{error()}</div>}

        {backendData() && (
          <pre class="mt-2 bg-gray-100 p-3 rounded text-sm overflow-auto">{JSON.stringify(backendData(), null, 2)}</pre>
        )}
      </div>
    </div>
  )
}
