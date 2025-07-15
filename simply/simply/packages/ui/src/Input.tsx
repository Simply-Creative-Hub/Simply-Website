import { type JSX, splitProps } from "solid-js"

interface InputProps extends JSX.InputHTMLAttributes<HTMLInputElement> {
  label?: string
  error?: string
}

export function Input(props: InputProps) {
  const [local, others] = splitProps(props, ["label", "error", "class"])

  return (
    <div class="space-y-1">
      {local.label && <label class="block text-sm font-medium text-gray-700">{local.label}</label>}
      <input
        class={`w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 ${
          local.error ? "border-red-500" : ""
        } ${local.class || ""}`}
        {...others}
      />
      {local.error && <p class="text-sm text-red-600">{local.error}</p>}
    </div>
  )
}
