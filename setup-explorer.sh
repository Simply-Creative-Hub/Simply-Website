#!/bin/bash
set -e

APP_NAME="explorer"
cd simply-turborepo

echo "📁 Creating folders for $APP_NAME..."
mkdir -p apps/$APP_NAME/{mobile,desktop,backend}

cd apps/$APP_NAME/mobile
echo "📦 Initializing mobile app..."
npx create-expo-app . --template blank
rm -f package-lock.json && rm -rf node_modules
yarn install

echo "📦 Installing Nativewind, Tailwind, etc..."
yarn add tailwindcss@3 react-native-svg
yarn add nativewind react-native-reanimated react-native-webview

echo "🛠️ Configuring Tailwind..."
npx tailwindcss init

cat > tailwind.config.js <<EOF
module.exports = {
  content: ["./App.{js,ts,jsx,tsx}", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: { extend: {} },
  plugins: [],
}
EOF

cat > babel.config.js <<EOF
module.exports = function (api) {
  api.cache(true);
  return {
    presets: ['babel-preset-expo'],
    plugins: ['nativewind/babel', 'react-native-reanimated/plugin'],
  };
};
EOF

cd ../desktop
npx create-tauri-app . --template vanilla

cd ../backend
python3 -m venv env && source env/bin/activate
pip install django
django-admin startproject backend .
deactivate

cd ../../../..

echo "✅ Explorer app is ready in apps/$APP_NAME"
