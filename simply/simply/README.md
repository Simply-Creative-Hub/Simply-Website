# Cross-Platform Full-Stack Monorepo with SolidStart

This is a comprehensive monorepo setup for building cross-platform applications using **SolidStart** (the Solid.js equivalent of TanStack Start) with shared code between web and desktop frontends, and a common Django backend.

## 🧠 Tech Stack

- **Frontend Framework**: SolidStart (Full-stack Solid.js framework)
- **Router**: @solidjs/router (built into SolidStart)
- **Monorepo Management**: Turborepo + Yarn Workspaces
- **Styling**: Tailwind CSS
- **Desktop Packaging**: Tauri for macOS, Linux, Windows
- **Backend**: Django server (Dockerized) with integrated Python + C++ modules

## 🏗️ Project Structure

The monorepo is structured as follows:

\`\`\`
.
├── apps/                  # All applications
│   ├── app1/              # First application
│   │   ├── web/           # SolidStart web app
│   │   ├── desktop/       # SolidStart + Tauri desktop app
│   │   └── backend/       # Django backend with C++ modules
│   ├── app2/              # Second application (same structure)
│   └── app3/              # Third application (desktop + backend only)
├── packages/              # Shared packages
│   └── ui/                # Shared UI components (Solid.js)
└── scripts/               # Utility scripts
    └── create-app.sh      # Script to scaffold new SolidStart apps
\`\`\`

## 🔄 SolidStart Features

- **File-based Routing**: Automatic routing based on file structure
- **Server-Side Rendering**: Built-in SSR capabilities
- **API Routes**: Full-stack API development within the same codebase
- **Type Safety**: End-to-end TypeScript support
- **Optimized Builds**: Production-ready optimizations

## 🚀 Getting Started

### Prerequisites

- Node.js (v18+)
- Yarn (v1.22+)
- Rust (for Tauri desktop apps)
- Python (v3.8+)
- C++ compiler (GCC, Clang, or MSVC)
- Docker (for containerized backend)

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone https://github.com/yourusername/cross-platform-monorepo.git
   cd cross-platform-monorepo
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   yarn install
   \`\`\`

3. Start development:
   \`\`\`bash
   yarn dev
   \`\`\`

### Creating a New SolidStart App

Use the provided script to scaffold a new SolidStart application:

\`\`\`bash
./scripts/create-app.sh my-new-app
\`\`\`

To create an app with specific components:

\`\`\`bash
./scripts/create-app.sh my-new-app --web --desktop --backend
\`\`\`

## 📦 Building for Production

Build all applications:

\`\`\`bash
yarn build
\`\`\`

Build a specific app:

\`\`\`bash
cd apps/app1/web
yarn build
\`\`\`

## 🧩 Key Differences from TanStack Start

While TanStack Start is React-focused, this monorepo uses **SolidStart** which provides:

- **Better Performance**: Solid.js's fine-grained reactivity
- **Smaller Bundle Sizes**: No virtual DOM overhead
- **Similar DX**: File-based routing, API routes, SSR
- **Full-stack Capabilities**: Everything TanStack Start offers but for Solid.js

## 🔄 Interoperability

- **Web Apps**: Use SolidStart's built-in API routes and server functions
- **Desktop Apps**: Communicate with Django backend via Tauri's invoke system
- **Shared Code**: UI components and business logic shared across platforms
- **Type Safety**: End-to-end TypeScript support across all layers

## 📁 App Structure

Each SolidStart app follows this structure:

\`\`\`
app/
├── src/
│   ├── routes/
│   │   ├── layout.tsx     # Layout component
│   │   ├── index.tsx      # Home page
│   │   ├── about.tsx      # About page
│   │   └── api/           # API routes
│   ├── app.tsx            # Root app component
│   └── global.css         # Global styles
├── app.config.ts          # SolidStart configuration
└── package.json
\`\`\`

## 🛠️ Development Commands

- \`yarn dev\` - Start all apps in development mode
- \`yarn build\` - Build all apps for production
- \`yarn lint\` - Run linting across all packages
- \`./scripts/create-app.sh <name>\` - Create a new SolidStart app

This setup provides the full-stack capabilities of TanStack Start but optimized for Solid.js, giving you the best of both worlds: React-like DX with Solid.js performance.
