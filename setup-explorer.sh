#!/bin/bash

# Exit on error
set -e

# Prompt for app name
read -p "Enter the name of your new app (e.g. explorer): " APP_NAME

# Monorepo root (assumes you're running the script from inside simply-turborepo)
MONOREPO_ROOT=$(pwd)

# Absolute path to the app
APP_PATH="$MONOREPO_ROOT/apps/$APP_NAME"

# Check Yarn
echo "📦 Checking Yarn..."
if ! command -v yarn &> /dev/null; then
  echo "❌ Yarn is not installed. Please install Yarn before continuing."
  exit 1
fi
echo "✅ Yarn is installed: $(yarn -v)"

# Create app folder structure
echo "📁 Creating folders for $APP_NAME..."
mkdir -p "$APP_PATH/mobile"
mkdir -p "$APP_PATH/desktop/src-tauri"
mkdir -p "$APP_PATH/backend"

# Initialize Expo mobile app
echo "📦 Setting up Expo mobile app for $APP_NAME"
npx create-expo-app "$APP_PATH/mobile" --template blank --no-install
cd "$APP_PATH/mobile"
yarn install

# Add shared mobile deps
echo "📦 Adding Nativewind, Tailwind, SVG, Reanimated, WebView..."
yarn add nativewind tailwindcss react-native-svg react-native-reanimated react-native-webview

# Create Tailwind config
npx tailwindcss init

# Create backend virtual environment
echo "🐍 Setting up Python backend..."
cd "$APP_PATH/backend"
python3 -m venv env
source env/bin/activate
pip install django
django-admin startproject backend .

# Create minimal Tauri desktop project
echo "🖥️  Setting up Tauri desktop app..."
cd "$APP_PATH/desktop"
npm create tauri-app@latest . -- --appName $APP_NAME --windowTitle "$APP_NAME Desktop" --no-install
yarn install

# Print final instructions
echo ""
echo "✅ Done! You can now:"
echo "➡️  Start mobile app:   cd apps/$APP_NAME/mobile && yarn start"
echo "➡️  Start desktop app:  cd apps/$APP_NAME/desktop && yarn tauri dev"
echo "➡️  Start backend API:  cd apps/$APP_NAME/backend && source env/bin/activate && python manage.py runserver"


