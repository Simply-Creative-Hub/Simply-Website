#!/bin/bash

set -e

# Define paths relative to this script (assumed to run from Simply/)
MONOREPO_DIR="simply-turborepo"
APP_NAME="explorer"
APP_DIR="$MONOREPO_DIR/apps/$APP_NAME"

echo "📦 Checking Yarn..."
if ! command -v yarn &> /dev/null; then
    echo "❌ Yarn is not installed. Please install Yarn before proceeding."
    exit 1
fi
echo "✅ Yarn is installed: $(yarn --version)"

echo "📁 Creating folders for $APP_NAME..."
mkdir -p "$APP_DIR/mobile"
mkdir -p "$APP_DIR/desktop"
mkdir -p "$APP_DIR/backend"

# --- Mobile setup ---
cd "$APP_DIR/mobile"
echo "📦 Setting up Expo mobile app for $APP_NAME"
npx create-expo-app . --template blank

echo "📦 Adding Nativewind, Tailwind, SVG, Reanimated, WebView..."
yarn add nativewind tailwindcss react-native-svg react-native-reanimated react-native-webview

echo "🛠️ Configuring Tailwind..."
npx tailwindcss init

cat > tailwind.config.js <<EOF
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./App.{js,jsx,ts,tsx}", "./src/**/*.{js,jsx,ts,tsx}"],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

cat > app.json <<EOF
{
  "expo": {
    "name": "$APP_NAME",
    "slug": "$APP_NAME",
    "plugins": ["nativewind"],
    "android": {
      "webView": {
        "implementation": "androidx.webkit.WebViewCompat"
      }
    }
  }
}
EOF

# --- Desktop setup ---
echo "📦 Setting up Tauri desktop app for $APP_NAME"
cd "$APP_DIR/desktop"
npm create tauri-app -- --template vanilla

# --- Backend setup ---
echo "📦 Setting up Django backend for $APP_NAME"
cd "$APP_DIR/backend"
python3 -m venv env
source env/bin/activate
pip install django
django-admin startproject backend .
deactivate

# --- Final instructions ---
echo ""
echo "✅ Done! You can now:"
echo "➡️  Start mobile app:   cd $APP_DIR/mobile && yarn start"
echo "➡️  Start desktop app:  cd $APP_DIR/desktop && yarn tauri dev"
echo "➡️  Start backend API:  cd $APP_DIR/backend && source env/bin/activate && python manage.py runserver"


