/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './App.{js,jsx,ts,tsx}',
    './src/**/*.{js,ts,jsx,tsx}',
    './src/components/**/*.{js,ts,jsx,tsx}',
    './src/app/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: '#3a6ae6',
        primaryborder: '#345cd4',
        primaryhover: '#678ef4',
        primarydisabled: '#5274cd',
        primarydisabledborder: '#455fa4',
        secondary: {
          DEFAULT: '#c8c8c8',
          light: '#c8c8c8',
          dark: '#494949',
        },
        secondaryborder: {
          DEFAULT: '#b2b2b2',
          light: '#b2b2b2',
          dark: '#303030',
        },
        secondaryhover: {
          DEFAULT: '#dddddd',
          light: '#dddddd',
          dark: '#827f7f',
        },
        secondarydisabled: {
          DEFAULT: '#929292',
          light: '#929292',
          dark: '#303030',
        },
        secondarydisabledborder: {
          DEFAULT: '#827f7f',
          light: '#827f7f',
          dark: '#222222',
        },
        tertiary: {
          DEFAULT: '#ffffff00',
          light: '#ffffff00',
          dark: '#00000000',
        },
        tertiaryhover: {
          DEFAULT: '#00000005',
          light: '#00000005',
          dark: '#fafafa03',
        },
        tertiaryhover: {
          DEFAULT: '#00000017',
          light: '#00000017',
          dark: '#fafafa10',
        },
        danger: '#ff1e56',
        dangerborder: '#d11a48',
        dangerhover: '#ff658b',
        dangerdisabled: '#bb3e5d',
        dangerdisabledborder: '#9f3a53',
        special: '#6914d4',
        specialborder: '#462094',
        specialhover: '#814af1',
        specialdisabled: '#5b42a2',
        specialdisabledborder: '#493b84',
        focus: '#61dafb',
      },
      fontFamily: {
        sans: ['Helvetica Now', 'sans-serif'],
        serif: ['Merriweather', 'serif'],
      },
    },
  },
  plugins: [],
};