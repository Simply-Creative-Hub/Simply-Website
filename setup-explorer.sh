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
echo "📱 Setting up Expo mobile app for $APP_NAME..."
cd "$APP_DIR/mobile"
npx create-expo-app . --template blank

echo "📦 Adding Nativewind, Tailwind, SVG, Reanimated, WebView..."
yarn add nativewind tailwindcss react-native-svg react-native-reanimated react-native-webview

echo "🛠️ Configuring Tailwind..."
yarn tailwindcss init

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
    },
    "ios": {
      "webView": {
        "useWebKit": true
      }
    }
  }
}
EOF

# --- Desktop setup ---
echo "🖥️  Setting up Tauri desktop app for $APP_NAME..."
cd "$APP_DIR/desktop"
npm create tauri-app -- --template vanilla

# --- Backend setup ---
echo "🧠 Setting up Django backend for $APP_NAME..."
cd "$APP_DIR/backend"
python3 -m venv env
source env/bin/activate
pip install django
django-admin startproject backend .
deactivate

# --- Update turbo.json ---
TURBO_JSON="$MONOREPO_DIR/turbo.json"
if [ -f "$TURBO_JSON" ]; then
  echo "🔗 Linking $APP_NAME in turbo.json..."
  node - <<EOF
const fs = require("fs");
const path = "$TURBO_JSON";
const json = JSON.parse(fs.readFileSync(path));

if (!json.pipeline) json.pipeline = {};

const addUnique = (arr, value) => {
  if (!arr.includes(value)) arr.push(value);
};

if (!json["extends"]) json["extends"] = [];
if (!json["pipeline"]["build"]) json["pipeline"]["build"] = { dependsOn: [], outputs: [] };

addUnique(json["extends"], "turborepo/presets");

const appsField = json["pipeline"]["build"]["dependsOn"];
addUnique(appsField, `apps/${APP_NAME}/mobile`);
addUnique(appsField, `apps/${APP_NAME}/desktop`);
addUnique(appsField, `apps/${APP_NAME}/backend`);

fs.writeFileSync(path, JSON.stringify(json, null, 2));
EOF
else
  echo "⚠️  turbo.json not found at $TURBO_JSON"
fi

# --- Final instructions ---
echo ""
echo "✅ Done! You can now:"
echo "➡️  Start mobile app:   cd $APP_DIR/mobile && yarn start"
echo "➡️  Start desktop app:  cd $APP_DIR/desktop && yarn tauri dev"
echo "➡️  Start backend API:  cd $APP_DIR/backend && source env/bin/activate && python manage.py runserver"
