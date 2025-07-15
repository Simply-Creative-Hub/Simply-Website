#!/bin/bash

# Script to create a new app in the monorepo using SolidStart
# Usage: ./scripts/create-app.sh <app-name> [--web] [--desktop] [--backend]

set -e

# Check if app name is provided
if [ -z "$1" ]; then
  echo "Error: App name is required"
  echo "Usage: ./scripts/create-app.sh <app-name> [--web] [--desktop] [--backend]"
  exit 1
fi

APP_NAME=$1
INCLUDE_WEB=false
INCLUDE_DESKTOP=false
INCLUDE_BACKEND=false

# Parse arguments
shift
while [[ $# -gt 0 ]]; do
  case "$1" in
    --web)
      INCLUDE_WEB=true
      shift
      ;;
    --desktop)
      INCLUDE_DESKTOP=true
      shift
      ;;
    --backend)
      INCLUDE_BACKEND=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: ./scripts/create-app.sh <app-name> [--web] [--desktop] [--backend]"
      exit 1
      ;;
  esac
done

# If no specific components are requested, include all
if [ "$INCLUDE_WEB" = false ] && [ "$INCLUDE_DESKTOP" = false ] && [ "$INCLUDE_BACKEND" = false ]; then
  INCLUDE_WEB=true
  INCLUDE_DESKTOP=true
  INCLUDE_BACKEND=true
fi

APP_DIR="apps/$APP_NAME"

# Create app directory
mkdir -p "$APP_DIR"

# Create app package.json
cat > "$APP_DIR/package.json" << EOF
{
  "name": "$APP_NAME",
  "private": true,
  "version": "0.0.0",
  "workspaces": [
    $([ "$INCLUDE_WEB" = true ] && echo "\"web\",")
    $([ "$INCLUDE_DESKTOP" = true ] && echo "\"desktop\",")
    $([ "$INCLUDE_BACKEND" = true ] && echo "\"backend\"")
  ],
  "scripts": {
    "dev": "turbo run dev",
    "build": "turbo run build",
    "lint": "turbo run lint"
  },
  "devDependencies": {
    "turbo": "^1.11.3"
  }
}
EOF

# Create turbo.json
cat > "$APP_DIR/turbo.json" << EOF
{
  "\$schema": "https://turbo.build/schema.json",
  "extends": ["//"],
  "pipeline": {
    "dev": {
      "persistent": true
    }
  }
}
EOF

# Create web app if requested
if [ "$INCLUDE_WEB" = true ]; then
  echo "Creating SolidStart web app..."
  mkdir -p "$APP_DIR/web/src/routes"
  
  # Create package.json
  cat > "$APP_DIR/web/package.json" << EOF
{
  "name": "$APP_NAME-web",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "solid-start dev",
    "build": "solid-start build",
    "start": "solid-start start",
    "lint": "eslint src --ext ts,tsx --report-unused-disable-directives --max-warnings 0"
  },
  "dependencies": {
    "solid-js": "^1.8.7",
    "@solidjs/start": "^0.4.10",
    "@solidjs/router": "^0.10.10",
    "vinxi": "^0.1.11",
    "ui": "*"
  },
  "devDependencies": {
    "typescript": "^5.3.3",
    "@typescript-eslint/eslint-plugin": "^6.15.0",
    "@typescript-eslint/parser": "^6.15.0",
    "eslint": "^8.56.0",
    "eslint-plugin-solid": "^0.13.0",
    "tailwindcss": "^3.4.0",
    "postcss": "^8.4.32",
    "autoprefixer": "^10.4.16"
  }
}
EOF

  # Create app.config.ts
  cat > "$APP_DIR/web/app.config.ts" << EOF
import { defineConfig } from "@solidjs/start/config"

export default defineConfig({
  server: {
    preset: "node-server",
    experimental: {
      websocket: true,
    },
  },
  vite: {
    server: {
      proxy: {
        "/api": {
          target: "http://localhost:8000",
          changeOrigin: true,
        },
      },
    },
  },
})
EOF

  # Create tsconfig.json
  cat > "$APP_DIR/web/tsconfig.json" << EOF
{
  "compilerOptions": {
    "target": "ESNext",
    "lib": ["DOM", "DOM.Iterable", "ES6"],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "ESNext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "preserve",
    "jsxImportSource": "solid-js",
    "types": ["@solidjs/start/env"],
    "paths": {
      "~/*": ["./src/*"],
      "ui/*": ["../../../packages/ui/src/*"]
    }
  },
  "include": ["src", "app.config.ts"],
  "exclude": ["node_modules", "dist", ".solid"]
}
EOF

  # Create tailwind.config.js
  cat > "$APP_DIR/web/tailwind.config.js" << EOF
/** @type {import('tailwindcss').Config} */
export default {
  content: ["./src/**/*.{js,ts,jsx,tsx}", "../../../packages/ui/src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

  # Create postcss.config.js
  cat > "$APP_DIR/web/postcss.config.js" << EOF
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

  # Create global CSS
  cat > "$APP_DIR/web/src/global.css" << EOF
@tailwind base;
@tailwind components;
@tailwind utilities;

body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
EOF

  # Create app.tsx
  cat > "$APP_DIR/web/src/app.tsx" << EOF
import { Router } from "@solidjs/router"
import { FileRoutes } from "@solidjs/start/router"
import { Suspense } from "solid-js"
import "./global.css"

export default function App() {
  return (
    <Router
      root={(props) => (
        <Suspense fallback={<div>Loading...</div>}>
          {props.children}
        </Suspense>
      )}
    >
      <FileRoutes />
    </Router>
  )
}
EOF

  # Create layout.tsx
  cat > "$APP_DIR/web/src/routes/layout.tsx" << EOF
import { RouteSectionProps } from "@solidjs/router"
import { Header } from "ui/Header"

export default function Layout(props: RouteSectionProps) {
  return (
    <div class="min-h-screen bg-gray-100">
      <Header title="$APP_NAME - Web" />
      <main class="container mx-auto p-4">
        {props.children}
      </main>
    </div>
  )
}
EOF

  # Create index.tsx
  cat > "$APP_DIR/web/src/routes/index.tsx" << EOF
import { createAsync } from "@solidjs/router"
import { Button } from "ui/Button"

async function fetchBackendData() {
  try {
    const response = await fetch("/api/hello")
    if (!response.ok) {
      throw new Error(\`HTTP error! status: \${response.status}\`)
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
      <p class="text-lg">Welcome to $APP_NAME Web Frontend (SolidStart)</p>

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
EOF

  # Create about.tsx
  cat > "$APP_DIR/web/src/routes/about.tsx" << EOF
export default function About() {
  return (
    <div class="space-y-4">
      <h1 class="text-3xl font-bold">About Page</h1>
      <p class="text-lg">This is the about page for $APP_NAME Web Frontend.</p>
      <p>
        This application is built with SolidStart, providing a full-stack Solid.js experience.
      </p>
      <p>Features include:</p>
      <ul class="list-disc list-inside space-y-1">
        <li>File-based routing</li>
        <li>Server-side rendering</li>
        <li>API routes</li>
        <li>Full-stack type safety</li>
        <li>Optimized builds</li>
      </ul>
    </div>
  )
}
EOF

  # Create API route
  mkdir -p "$APP_DIR/web/src/routes/api"
  cat > "$APP_DIR/web/src/routes/api/hello.ts" << EOF
import { json } from "@solidjs/router"

export async function GET() {
  return json({
    message: "Hello from $APP_NAME SolidStart API!",
    timestamp: new Date().toISOString(),
    status: "success",
    framework: "SolidStart"
  })
}
EOF
fi

# Create desktop app if requested (similar structure but with Tauri integration)
if [ "$INCLUDE_DESKTOP" = true ]; then
  echo "Creating SolidStart desktop app with Tauri..."
  mkdir -p "$APP_DIR/desktop/src/routes"
  mkdir -p "$APP_DIR/desktop/src-tauri/src"
  
  # Copy template files from app1/desktop
  cp -r apps/app1/desktop/src-tauri/Cargo.toml "$APP_DIR/desktop/src-tauri/"
  
  # Create tauri.conf.json
  cat > "$APP_DIR/desktop/src-tauri/tauri.conf.json" << EOF
{
  "build": {
    "beforeDevCommand": "yarn dev",
    "beforeBuildCommand": "yarn build",
    "devPath": "http://localhost:1420",
    "distDir": "../dist",
    "withGlobalTauri": false
  },
  "package": {
    "productName": "$APP_NAME Desktop",
    "version": "0.0.0"
  },
  "tauri": {
    "allowlist": {
      "all": false,
      "shell": {
        "all": false,
        "open": true
      },
      "http": {
        "all": true,
        "request": true,
        "scope": ["http://localhost:8000/*"]
      },
      "fs": {
        "all": false,
        "readFile": true,
        "writeFile": true,
        "readDir": true,
        "createDir": true,
        "exists": true
      }
    },
    "bundle": {
      "active": true,
      "icon": [
        "icons/32x32.png",
        "icons/128x128.png",
        "icons/128x128@2x.png",
        "icons/icon.icns",
        "icons/icon.ico"
      ],
      "identifier": "com.$APP_NAME.desktop",
      "targets": "all"
    },
    "security": {
      "csp": null
    },
    "updater": {
      "active": false
    },
    "windows": [
      {
        "fullscreen": false,
        "resizable": true,
        "title": "$APP_NAME Desktop",
        "width": 800,
        "height": 600
      }
    ]
  }
}
EOF

  # Create main.rs
  cat > "$APP_DIR/desktop/src-tauri/src/main.rs" << EOF
#![cfg_attr(
    all(not(debug_assertions), target_os = "windows"),
    windows_subsystem = "windows"
)]

use tauri::{Manager, Window};

// Learn more about Tauri commands at https://tauri.app/v1/guides/features/command
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

#[tauri::command]
async fn call_backend(window: Window, endpoint: String) -> Result<String, String> {
    let client = reqwest::Client::new();
    let url = format!("http://localhost:8000{}", endpoint);
    
    match client.get(&url).send().await {
        Ok(response) => {
            match response.text().await {
                Ok(text) => Ok(text),
                Err(e) => Err(format!("Failed to get response text: {}", e))
            }
        },
        Err(e) => Err(format!("Failed to call backend: {}", e))
    }
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![greet, call_backend])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
EOF

  # Create package.json
  cat > "$APP_DIR/desktop/package.json" << EOF
{
  "name": "$APP_NAME-desktop",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview",
    "tauri": "tauri",
    "lint": "eslint src --ext ts,tsx --report-unused-disable-directives --max-warnings 0"
  },
  "dependencies": {
    "solid-js": "^1.8.7",
    "@solidjs/start": "^0.4.10",
    "@solidjs/router": "^0.10.10",
    "vinxi": "^0.1.11",
    "@tauri-apps/api": "^1.5.2",
    "ui": "*",
    "tailwindcss": "^3.4.0",
    "postcss": "^8.4.32",
    "autoprefixer": "^10.4.16"
  },
  "devDependencies": {
    "typescript": "^5.3.3",
    "vite": "^5.0.10",
    "vite-plugin-solid": "^2.8.0",
    "@typescript-eslint/eslint-plugin": "^6.15.0",
    "@typescript-eslint/parser": "^6.15.0",
    "eslint": "^8.56.0",
    "eslint-plugin-solid": "^0.13.0",
    "@tauri-apps/cli": "^1.5.8"
  }
}
EOF

  # Create App.tsx
  cat > "$APP_DIR/desktop/src/App.tsx" << EOF
import { Outlet } from '@solidjs/router';
import { Header } from 'ui/Header';

function App() {
  return (
    <div class="min-h-screen bg-gray-100">
      <Header title="$APP_NAME - Desktop" />
      <main class="container mx-auto p-4">
        <Outlet />
      </main>
    </div>
  );
}

export default App;
EOF

  # Create Home route
  cat > "$APP_DIR/desktop/src/routes/home.tsx" << EOF
import { createSignal, createResource } from 'solid-js';
import { invoke } from '@tauri-apps/api/tauri';
import { Button } from 'ui/Button';

export function Home() {
  const [name, setName] = createSignal('');
  const [greetMsg, setGreetMsg] = createSignal('');
  const [backendData, setBackendData] = createSignal<any>(null);
  const [loading, setLoading] = createSignal(false);
  const [error, setError] = createSignal<string | null>(null);

  async function greet() {
    setGreetMsg(await invoke('greet', { name: name() }));
  }

  async function fetchFromBackend() {
    setLoading(true);
    setError(null);
    try {
      const response = await invoke('call_backend', { endpoint: '/api/hello' });
      setBackendData(JSON.parse(response as string));
    } catch (err) {
      setError(\`Error: \${err}\`);
      console.error(err);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div class="space-y-6">
      <h1 class="text-3xl font-bold">Home Page</h1>
      <p class="text-lg">Welcome to $APP_NAME Desktop Frontend</p>
      
      <div class="p-4 bg-white rounded-lg shadow">
        <div class="mb-4">
          <input
            class="border p-2 rounded w-full"
            id="greet-input"
            onChange={(e) => setName(e.currentTarget.value)}
            placeholder="Enter a name..."
          />
          <Button onClick={greet} class="mt-2">Greet</Button>
        </div>
        
        <p class="mt-2">{greetMsg()}</p>
      </div>
      
      <div class="p-4 bg-white rounded-lg shadow">
        <h2 class="text-xl font-semibold mb-2">Backend Communication:</h2>
        <Button onClick={fetchFromBackend} disabled={loading()}>
          {loading() ? 'Loading...' : 'Fetch from Backend'}
        </Button>
        
        {error() && (
          <div class="mt-2 p-2 bg-red-100 text-red-700 rounded">
            {error()}
          </div>
        )}
        
        {backendData() && (
          <pre class="mt-2 bg-gray-100 p-3 rounded">
            {JSON.stringify(backendData(), null, 2)}
          </pre>
        )}
      </div>
    </div>
  );
}
EOF

  # Create About route
  cat > "$APP_DIR/desktop/src/routes/about.tsx" << EOF
export function About() {
  return (
    <div class="space-y-4">
      <h1 class="text-3xl font-bold">About Page</h1>
      <p class="text-lg">This is the about page for $APP_NAME Desktop Frontend.</p>
      <p>
        This application is built with SolidStart and Tauri, providing a native desktop experience
        while using web technologies for the UI.
      </p>
      <p>
        The app communicates with the backend through Tauri's invoke system,
        which bridges the gap between the web frontend and native capabilities.
      </p>
    </div>
  );
}
EOF
fi

# Create backend app if requested
if [ "$INCLUDE_BACKEND" = true ]; then
  echo "Creating Django backend..."
  mkdir -p "$APP_DIR/backend/backend"
  mkdir -p "$APP_DIR/backend/api"
  mkdir -p "$APP_DIR/backend/cpp_modules"
  
  # Copy template files from app1/backend
  cp -r apps/app1/backend/requirements.txt "$APP_DIR/backend/"
  cp -r apps/app1/backend/manage.py "$APP_DIR/backend/"
  cp -r apps/app1/backend/Dockerfile "$APP_DIR/backend/"
  cp -r apps/app1/backend/docker-compose.yml "$APP_DIR/backend/"
  cp -r apps/app1/backend/backend/settings.py "$APP_DIR/backend/backend/"
  cp -r apps/app1/backend/backend/urls.py "$APP_DIR/backend/backend/"
  cp -r apps/app1/backend/backend/wsgi.py "$APP_DIR/backend/backend/"
  cp -r apps/app1/backend/backend/asgi.py "$APP_DIR/backend/backend/"
  cp -r apps/app1/backend/api/apps.py "$APP_DIR/backend/api/"
  cp -r apps/app1/backend/api/urls.py "$APP_DIR/backend/api/"
  cp -r apps/app1/backend/api/views.py "$APP_DIR/backend/api/"
  cp -r apps/app1/backend/cpp_modules/CMakeLists.txt "$APP_DIR/backend/cpp_modules/"
  cp -r apps/app1/backend/cpp_modules/calculator.cpp "$APP_DIR/backend/cpp_modules/"
  
  # Create __init__.py files
  touch "$APP_DIR/backend/backend/__init__.py"
  touch "$APP_DIR/backend/api/__init__.py"
fi

echo "SolidStart app '$APP_NAME' created successfully!"
echo "Components included:"
[ "$INCLUDE_WEB" = true ] && echo "- SolidStart web frontend"
[ "$INCLUDE_DESKTOP" = true ] && echo "- SolidStart desktop frontend (with Tauri)"
[ "$INCLUDE_BACKEND" = true ] && echo "- Django backend"
echo ""
echo "To start development:"
echo "cd apps/$APP_NAME && yarn dev"
