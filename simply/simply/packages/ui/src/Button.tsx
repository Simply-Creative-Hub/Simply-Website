import { type JSX, splitProps } from "solid-js"

interface ButtonProps extends JSX.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "primary" | "secondary" | "outline"
  size?: "sm" | "md" | "lg"
  children: JSX.Element
}

export function Button(props: ButtonProps) {
  const [local, others] = splitProps(props, ["variant", "size", "children", "class"])

  const variantClasses = {
    primary: "bg-blue-600 hover:bg-blue-700 text-white",
    secondary: "bg-gray-200 hover:bg-gray-300 text-gray-800",
    outline: "bg-transparent border border-blue-600 text-blue-600 hover:bg-blue-50",
  }

  const sizeClasses = {
    sm: "px-2 py-1 text-sm",
    md: "px-4 py-2",
    lg: "px-6 py-3 text-lg",
  }

  const variant = local.variant || "primary"
  const size = local.size || "md"

  const className = `${variantClasses[variant]} ${sizeClasses[size]} rounded font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 disabled:opacity-50 disabled:cursor-not-allowed ${local.class || ""}`

  return (
    <button class={className} {...others}>
      {local.children}
    </button>
  )
}
