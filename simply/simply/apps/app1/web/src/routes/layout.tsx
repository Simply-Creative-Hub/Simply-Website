import type { RouteSectionProps } from "@solidjs/router"
import { Header } from "ui/Header"

export default function Layout(props: RouteSectionProps) {
  return (
    <div class="min-h-screen bg-gray-100">
      <Header title="App 1 - Web" />
      <main class="container mx-auto p-4">{props.children}</main>
    </div>
  )
}
