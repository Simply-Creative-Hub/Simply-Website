#!/bin/bash
set -e

read -p "Enter the name of the new app to add: " APP_NAME
if [ -z "$APP_NAME" ]; then
  echo "❌ App name is required. Exiting."
  exit 1
fi

cd simply-turborepo

echo "📁 Creating folders for $APP_NAME..."
mkdir -p apps/$APP_NAME/{mobile,web,desktop,backend}

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

cd ../web
npx create-expo-app . --template blank
rm -f package-lock.json && rm -rf node_modules
yarn install

cd ../desktop
npx create-tauri-app . --template vanilla

cd ../backend
python3 -m venv env && source env/bin/activate
pip install django
django-admin startproject backend .
deactivate

cd ../../../..

echo "✅ App '$APP_NAME' added to monorepo."
