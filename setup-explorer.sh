#!/bin/bash

APP_NAME="explorer"
MONOREPO_DIR="simply-turborepo"
APPS_DIR="$MONOREPO_DIR/apps"

echo "📦 Checking Yarn..."
if ! command -v yarn &> /dev/null; then
    echo "❌ Yarn is not installed. Please install Yarn and rerun this script."
    exit 1
fi

echo "📁 Creating folders for $APP_NAME..."

mkdir -p $APPS_DIR/$APP_NAME/mobile
mkdir -p $APPS_DIR/$APP_NAME/desktop/src-tauri
mkdir -p $APPS_DIR/$APP_NAME/backend

echo "📦 Setting up Expo mobile app for $APP_NAME"
cd $APPS_DIR/$APP_NAME/mobile
npx create-expo-app . --template blank
yarn install

echo "📦 Adding Nativewind, Tailwind, SVG, Reanimated, WebView..."
yarn add nativewind tailwindcss react-native-svg react-native-reanimated react-native-webview

echo "✅ Mobile app setup complete!"

cd ../../../../..

echo "📦 Setting up Tauri desktop app for $APP_NAME"
cd $APPS_DIR/$APP_NAME/desktop
yarn init -y
yarn add react-native
cargo init --bin
npx tauri init --app-name "$APP_NAME" --window-title "$APP_NAME" --dist-dir "../mobile/dist" --dev-path "http://localhost:8081" --before-build-command "yarn build" --before-dev-command "yarn start" --force

echo "✅ Desktop app setup complete!"

echo "📦 Setting up Python backend for $APP_NAME"
cd $APPS_DIR/$APP_NAME/backend
python3 -m venv env
source env/bin/activate
pip install django
django-admin startproject backend .

echo "✅ Backend API setup complete!"

cd ../../../../..

echo "✅ Done! You can now:"
echo "➡️  Start mobile app:   cd $APPS_DIR/$APP_NAME/mobile && yarn start"
echo "➡️  Start desktop app:  cd $APPS_DIR/$APP_NAME/desktop && yarn tauri dev"
echo "➡️  Start backend API:  cd $APPS_DIR/$APP_NAME/backend && source env/bin/activate && python manage.py runserver"

