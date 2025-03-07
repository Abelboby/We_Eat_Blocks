import { BrowserRouter as Router, Routes, Route, useLocation } from 'react-router-dom';
import { useState, useEffect, createContext } from 'react';
import { AnimatePresence } from 'framer-motion';
import Navbar from './components/Navbar';
import SplashScreen from './components/SplashScreen';
import { mainRoutes, dashboardRoutes } from './routes';
import DashboardLayout from './components/layouts/DashboardLayout';

// Create Context without theme toggle
export const ThemeContext = createContext({
  isDarkTheme: true,
});

const AppContent = () => {
  const location = useLocation();
  const isDashboard = location.pathname.startsWith('/dashboard');
  const [showSplash, setShowSplash] = useState(true);

  return (
    <ThemeContext.Provider value={{ isDarkTheme: true }}>
      <AnimatePresence mode="wait">
        {showSplash && (
          <SplashScreen onComplete={() => setShowSplash(false)} />
        )}
      </AnimatePresence>

      <div className={`min-h-screen transition-opacity duration-500 ${showSplash ? 'opacity-0' : 'opacity-100'}`}>
        {!isDashboard && <Navbar />}
        <Routes>
          {/* Main Routes */}
          {mainRoutes.map((route) => (
            <Route key={route.path} path={route.path} element={route.element} />
          ))}
          
          {/* Dashboard Routes */}
          {dashboardRoutes.map((route) => (
            <Route 
              key={route.path} 
              path={route.path} 
              element={<DashboardLayout>{route.element}</DashboardLayout>} 
            />
          ))}
        </Routes>
      </div>
    </ThemeContext.Provider>
  );
};

function App() {
  return (
    <Router>
      <AppContent />
    </Router>
  );
}

export default App;
