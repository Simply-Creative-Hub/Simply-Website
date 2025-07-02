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
npx create-expo-app . --template blank --yes

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

cat > babel.config.js <<EOF
module.exports = function (api) {
  api.cache(true);
  return {
    presets: ['babel-preset-expo'],
    plugins: ['nativewind/babel', 'react-native-reanimated/plugin'],
  };
};
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

# Example component
mkdir -p src/components
cat > src/components/AnimatedBox.js <<EOF
import Animated, { useSharedValue, useAnimatedStyle, withTiming } from 'react-native-reanimated';
import { Pressable } from 'react-native';

export default function AnimatedBox() {
  const scale = useSharedValue(1);
  const animStyle = useAnimatedStyle(() => ({ transform: [{ scale: scale.value }] }));

  return (
    <Pressable
      onPress={() => {
        scale.value = withTiming(scale.value === 1 ? 1.2 : 1, { duration: 300 });
      }}
    >
      <Animated.View style={[{ width: 100, height: 100, backgroundColor: 'blue' }, animStyle]} />
    </Pressable>
  );
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

# --- Link new app in turbo.json ---
cd "../../../$MONOREPO_DIR"
TURBO_JSON="turbo.json"

if [ -f "$TURBO_JSON" ]; then
  echo "🔗 Registering app in turbo.json..."
  TMP_FILE=$(mktemp)

  jq --arg appName "$APP_NAME" '
    .pipeline["build:\($appName)"] = {dependsOn: ["^build"], outputs: ["apps/\($appName)/**/dist"]}
  ' "$TURBO_JSON" > "$TMP_FILE" && mv "$TMP_FILE" "$TURBO_JSON"
else
  echo "⚠️  turbo.json not found in $MONOREPO_DIR. Skipping linking step."
fi

# --- Final instructions ---
echo ""
echo "✅ Done! Your explorer app is set up in:"
echo "   $APP_DIR"
echo ""
echo "➡️  Start mobile app:   cd $APP_DIR/mobile && yarn start"
echo "➡️  Start desktop app:  cd $APP_DIR/desktop && yarn tauri dev"
echo "➡️  Start backend API:  cd $APP_DIR/backend && source env/bin/activate && python manage.py runserver"
