import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'

function App() {
  const [count, setCount] = useState(0)

  return (
    <div className="min-h-screen bg-gradient-to-r from-blue-500 to-purple-600 flex flex-col items-center justify-center p-4">
      <div className="flex space-x-8 mb-6">
        <a href="https://vite.dev" target="_blank" className="transition-transform hover:scale-110">
          <img src={viteLogo} className="h-24 w-24" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank" className="transition-transform hover:scale-110">
          <img src={reactLogo} className="h-24 w-24 animate-spin-slow" alt="React logo" />
        </a>
      </div>
      <h1 className="text-4xl font-bold text-white mb-8 text-center">Tailwind + React</h1>
      <div className="bg-white rounded-lg shadow-xl p-8 max-w-md w-full">
        <button 
          onClick={() => setCount((count) => count + 1)}
          className="w-full bg-gradient-to-r from-green-400 to-blue-500 hover:from-pink-500 hover:to-yellow-500 text-white font-bold py-2 px-4 rounded-md transition-all duration-300 mb-4"
        >
          Count is {count}
        </button>
        <p className="text-gray-700 text-center">
          Edit <code className="bg-gray-100 px-1 py-0.5 rounded text-pink-500">src/App.jsx</code> and save to test HMR
        </p>
      </div>
      <p className="mt-8 text-white text-opacity-80 text-center">
        Click on the Vite and React logos to learn more
      </p>
      <div className="mt-8 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
        <div className="bg-white p-4 rounded-lg shadow hover:shadow-lg transition-shadow">
          <h2 className="text-lg font-semibold text-gray-800">Responsive</h2>
          <p className="text-gray-600">This card changes layout on different screen sizes</p>
        </div>
        <div className="bg-white p-4 rounded-lg shadow hover:shadow-lg transition-shadow">
          <h2 className="text-lg font-semibold text-gray-800">Interactive</h2>
          <p className="text-gray-600">Hover and click states are styled with Tailwind</p>
        </div>
        <div className="bg-white p-4 rounded-lg shadow hover:shadow-lg transition-shadow">
          <h2 className="text-lg font-semibold text-gray-800">Customizable</h2>
          <p className="text-gray-600">Extend Tailwind with your own custom styles</p>
        </div>
      </div>
    </div>
  )
}

export default App
