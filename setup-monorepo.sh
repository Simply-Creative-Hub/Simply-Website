#!/bin/bash
set -e

# Ask for app name
read -p "Enter the name of your main app (e.g. main-app): " APP_NAME
if [ -z "$APP_NAME" ]; then
  echo "❌ App name is required. Exiting."
  exit 1
fi

MONOREPO_NAME="simply-turborepo"

echo "📦 Checking Yarn..."
if ! command -v yarn &> /dev/null; then
  echo "❌ Yarn not found. Please install it first: https://classic.yarnpkg.com/lang/en/docs/install/"
  exit 1
else
  echo "✅ Yarn is installed: $(yarn --version)"
fi

echo "📦 Creating monorepo: $MONOREPO_NAME"
npx create-turbo@latest $MONOREPO_NAME --package-manager=yarn
cd $MONOREPO_NAME

echo "📁 Creating folders..."
mkdir -p apps/$APP_NAME/{mobile,desktop,backend} packages/shared

echo "📦 Initializing Expo mobile app..."
cd apps/$APP_NAME/mobile
npx create-expo-app . --template blank
rm -f package-lock.json && rm -rf node_modules
yarn install

echo "📦 Installing Nativewind, Tailwind, SVG, Reanimated, WebView..."
yarn add tailwindcss@3 react-native-svg
yarn add nativewind react-native-reanimated react-native-webview

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

cd ../desktop
echo "🖥️  Setting up Tauri Desktop Shell..."
npx create-tauri-app . --template vanilla

cd ../backend
echo "🐍 Setting up Django backend..."
python3 -m venv env && source env/bin/activate
pip install django
django-admin startproject backend .
deactivate

cd ../../../

echo "📝 Creating README and .gitignore..."
cat > README.md <<EOF
# $MONOREPO_NAME

Full-stack cross-platform monorepo.

- Mobile: React Native + Expo
- Desktop: React Native + Tauri
- Backend: Django + C++
- Styling: Tailwind via Nativewind
EOF

cat > .gitignore <<EOF
node_modules
.env
*.pyc
__pycache__/
apps/*/backend/env/
EOF

echo ""
echo "✅ Done! Your monorepo is ready at $MONOREPO_NAME/apps/$APP_NAME"
echo "➡️  Start mobile app:   cd apps/$APP_NAME/mobile && yarn start"
echo "➡️  Start desktop app:  cd apps/$APP_NAME/desktop && yarn tauri dev"
echo "➡️  Start backend API:  cd apps/$APP_NAME/backend && source env/bin/activate && python manage.py runserver"
