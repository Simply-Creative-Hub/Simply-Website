#!/bin/bash

set -e

MONOREPO_NAME="simply-turborepo"
APP_NAME="myapp"

# Step 1: Ensure Yarn (Classic) is installed
if ! command -v yarn &> /dev/null; then
  echo "📦 Yarn not found. Installing Yarn Classic..."
  npm install -g yarn
else
  echo "📦 Yarn is already installed: $(yarn --version)"
fi

# Step 2: Create the monorepo with Turbo, using Yarn
echo "📦 Creating monorepo: $MONOREPO_NAME with Yarn..."
npx create-turbo@latest $MONOREPO_NAME --package-manager yarn
cd $MONOREPO_NAME

# Step 3: Create folder structure
echo "📁 Creating app folders for: $APP_NAME"
mkdir -p apps/$APP_NAME/{mobile,web,desktop,backend}
mkdir -p packages/{ui,logic,python,cpp,native-modules,config}

# Step 4: Clean default apps
rm -rf apps/docs apps/web || true

# Step 5: Write root package.json with Yarn workspaces
cat > package.json <<EOF
{
  "name": "$MONOREPO_NAME",
  "private": true,
  "workspaces": [
    "apps/*/*",
    "packages/*"
  ],
  "devDependencies": {
    "turbo": "^1.12.0"
  }
}
EOF

# Step 6: Write root tsconfig.json
cat > tsconfig.json <<EOF
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@ui/*": ["packages/ui/*"],
      "@logic/*": ["packages/logic/*"]
    }
  }
}
EOF

# Step 7: Initialize Expo mobile app
echo "🌀 Initializing Expo mobile app"
cd apps/$APP_NAME/mobile
npx create-expo-app . --yes
yarn add nativewind tailwindcss react-native-svg
npx tailwindcss init
cd ../../../..

# Step 8: Set up Expo Web by copying from mobile
echo "🌐 Linking Expo Web to mobile"
cp -r apps/$APP_NAME/mobile/* apps/$APP_NAME/web/
touch apps/$APP_NAME/web/web.config.js

# Step 9: Set up desktop app shell with Tauri
echo "🖥️ Setting up desktop shell with Tauri"
cd apps/$APP_NAME/desktop
cargo install create-tauri-app --force
npx create-tauri-app . --template vanilla
cd ../../..

# Step 10: Set up backend Django server
echo "🐍 Setting up Django backend"
cd apps/$APP_NAME/backend
python3 -m venv env
source env/bin/activate
pip install django
django-admin startproject backend .
deactivate
cd ../../..

# Step 11: Shared Tailwind config package
echo "⚙️ Creating shared Tailwind config"
mkdir -p packages/config
cat > packages/config/tailwind.config.js <<EOF
module.exports = {
  content: ["../../apps/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

# Step 12: Dummy shared packages
echo "📦 Dummy shared packages"
echo "export const Button = () => null;" > packages/ui/index.ts
echo "export const sum = (a, b) => a + b;" > packages/logic/index.ts

# Step 13: Final install
echo "📦 Installing all dependencies with Yarn"
yarn install

echo "✅ Setup complete: $MONOREPO_NAME created inside ~/Simply"