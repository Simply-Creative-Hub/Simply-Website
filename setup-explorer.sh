#!/bin/bash

set -e

# Constants
MONOREPO_DIR="simply-turborepo"
APP_NAME="explorer"
APP_DIR="$MONOREPO_DIR/apps/$APP_NAME"

echo "📦 Checking Yarn..."
if ! command -v yarn &> /dev/null; then
  echo "❌ Yarn is not installed. Please install it before continuing."
  exit 1
fi
echo "✅ Yarn is installed: $(yarn --version)"

echo "📁 Creating folders for $APP_NAME..."
mkdir -p "$APP_DIR/mobile"
mkdir -p "$APP_DIR/desktop"
mkdir -p "$APP_DIR/backend"

# --- Mobile setup ---
echo "📦 Setting up Expo mobile app for $APP_NAME..."
cd "$APP_DIR/mobile"
npx create-expo-app . --template blank

echo "📦 Adding Nativewind, Tailwind, SVG, Reanimated, WebView..."
yarn add nativewind tailwindcss react-native-svg react-native-reanimated react-native-webview

echo "📦 Running yarn install to ensure binaries are available..."
yarn install

echo "🛠️ Initializing Tailwind config..."
if [ -f "./node_modules/.bin/tailwindcss" ]; then
  ./node_modules/.bin/tailwindcss init
else
  echo "⚠️ Tailwind binary not found. Skipping tailwind.config.js generation."
fi

echo "🛠️ Writing custom Tailwind config and app.json..."
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
echo "📦 Setting up Tauri desktop app for $APP_NAME..."
cd "$APP_DIR/desktop"
npm create tauri-app -- --template vanilla

# --- Backend setup ---
echo "📦 Setting up Django backend for $APP_NAME..."
cd "$APP_DIR/backend"
python3 -m venv env
source env/bin/activate
pip install django
django-admin startproject backend .
deactivate

# --- Register in turbo.json ---
cd "../../../../"  # Back to Simply/
TURBO_JSON="$MONOREPO_DIR/turbo.json"
if [ -f "$TURBO_JSON" ]; then
  echo "🔗 Registering $APP_NAME in turbo.json..."
  TMP_FILE=$(mktemp)
  jq --arg app "$APP_NAME" '.pipeline += {($app): {"dependsOn":["^"], "outputs":["dist/**", "build/**"]}}' "$TURBO_JSON" > "$TMP_FILE" && mv "$TMP_FILE" "$TURBO_JSON"
else
  echo "⚠️ turbo.json not found, skipping linking."
fi

# --- Done ---
echo ""
echo "✅ Setup complete!"
echo "➡️  Mobile:   cd $APP_DIR/mobile && yarn start"
echo "➡️  Desktop:  cd $APP_DIR/desktop && yarn tauri dev"
echo "➡️  Backend:  cd $APP_DIR/backend && source env/bin/activate && python manage.py runserver"