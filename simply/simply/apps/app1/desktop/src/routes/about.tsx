export default function About() {
  return (
    <div class="space-y-4">
      <h1 class="text-3xl font-bold">About Page</h1>
      <p class="text-lg">This is the about page for App 1 Desktop Frontend.</p>
      <p>
        This application is built with SolidStart + Tauri, providing a native desktop experience while using SolidStart
        for the UI framework.
      </p>
      <p>Key features:</p>
      <ul class="list-disc list-inside space-y-1">
        <li>Native desktop performance with Tauri</li>
        <li>SolidStart for full-stack capabilities</li>
        <li>File-based routing</li>
        <li>Rust backend integration</li>
        <li>Cross-platform compatibility</li>
      </ul>
    </div>
  )
}
