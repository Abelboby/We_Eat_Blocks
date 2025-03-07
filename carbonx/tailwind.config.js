module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  darkMode: 'class', // enabling dark mode (class strategy)
  theme: {
    extend: {
      fontFamily: {
        display: ['Space Grotesk', 'sans-serif'],
        body: ['Inter', 'sans-serif'],
        accent: ['Manrope', 'sans-serif'],
      },
      colors: {
        'carbon': {
          50: '#f1f9f5',
          100: '#dcefe3',
          200: '#bddecb',
          300: '#92c7ad',
          400: '#64ab8c',
          500: '#428f6e',
          600: '#2f7259',
          700: '#275c49',
          800: '#22493c',
          900: '#1e3c33',
          950: '#0f231e',
        },
        'forest': {
          50: '#eefdf5',
          100: '#d7f9e7',
          200: '#b2f1d0',
          300: '#7ee4b0',
          400: '#42ce87',
          500: '#22b36c',
          600: '#159057',
          700: '#137348',
          800: '#145c3c',
          900: '#134c34',
          950: '#07291c',
        },
        'ocean': {
          50: '#f0faff',
          100: '#e0f4fe',
          200: '#bae8fd',
          300: '#7dd7fc',
          400: '#38c0f9',
          500: '#0ea5ea',
          600: '#0287cd',
          700: '#036ca6',
          800: '#075a89',
          900: '#0c4a72',
          950: '#082f4a',
        },
        'earth': {
          50: '#f9f7f2',
          100: '#f1ebe1',
          200: '#e3d6c1',
          300: '#d1ba99',
          400: '#c0a077',
          500: '#b18959',
          600: '#a0764a',
          700: '#85603d',
          800: '#6c4e35',
          900: '#59412e',
          950: '#302217',
        },
      },
      animation: {
        'float': 'float 6s ease-in-out infinite',
        'pulse-slow': 'pulse 6s cubic-bezier(0.4, 0, 0.6, 1) infinite',
        'glow': 'glow 2s ease-in-out infinite alternate',
      },
      keyframes: {
        float: {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-10px)' },
        },
        glow: {
          '0%': { boxShadow: '0 0 5px rgba(66, 207, 134, 0.7)' },
          '100%': { boxShadow: '0 0 20px rgba(66, 207, 134, 0.9)' },
        }
      },
      backgroundImage: {
        'gradient-radial': 'radial-gradient(var(--tw-gradient-stops))',
        'hero-pattern': "url('/src/assets/images/grid-pattern.svg')",
      },
      boxShadow: {
        'glass': '0 8px 32px 0 rgba(31, 38, 135, 0.07)',
      }
    },
  },
  plugins: [],
}
