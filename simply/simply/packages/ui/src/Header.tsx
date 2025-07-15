import type { JSX } from "solid-js"

interface HeaderProps {
  title: string
  children?: JSX.Element
}

export function Header(props: HeaderProps) {
  return (
    <header class="bg-white shadow-sm border-b">
      <div class="container mx-auto px-4 py-4 flex justify-between items-center">
        <h1 class="text-xl font-bold text-gray-800">{props.title}</h1>
        <nav class="flex space-x-4">
          <a href="/" class="text-gray-600 hover:text-gray-800 transition-colors">
            Home
          </a>
          <a href="/about" class="text-gray-600 hover:text-gray-800 transition-colors">
            About
          </a>
        </nav>
        {props.children}
      </div>
    </header>
  )
}
