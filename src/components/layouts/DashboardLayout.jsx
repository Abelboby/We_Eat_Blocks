import { motion, AnimatePresence } from 'framer-motion';
import { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';

const sidebarLinks = [
  { name: 'Overview', path: '/dashboard', icon: 'M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6' },
  { name: 'Carbon Pools', path: '/dashboard/carbon-pools', icon: 'M13 10V3L4 14h7v7l9-11h-7z' },
  { name: 'Explorer', path: '/dashboard/explorer', icon: 'M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z' },
  { name: 'Cross-Chain', path: '/dashboard/cross-chain', icon: 'M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4' },
  { name: 'Retirements', path: '/dashboard/retirements', icon: 'M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16' },
];

const DashboardLayout = ({ children }) => {
  const [isSidebarOpen, setIsSidebarOpen] = useState(true);
  const location = useLocation();

  return (
    <div className="flex h-screen bg-[#0F172A] overflow-hidden">
      {/* Sidebar */}
      <AnimatePresence mode="wait">
        <motion.div
          initial={{ width: isSidebarOpen ? 240 : 80 }}
          animate={{ width: isSidebarOpen ? 240 : 80 }}
          exit={{ width: 80 }}
          transition={{ duration: 0.3, ease: "easeInOut" }}
          className="h-full bg-[#1E293B]/50 backdrop-blur-xl border-r border-[#76EAD7]/10 flex flex-col relative"
        >
          {/* Logo */}
          <div className={`p-6 flex items-center ${isSidebarOpen ? 'justify-between' : 'justify-center'}`}>
            <Link to="/">
              <motion.div
                initial={{ opacity: isSidebarOpen ? 1 : 0 }}
                animate={{ opacity: isSidebarOpen ? 1 : 0 }}
                transition={{ duration: 0.2 }}
                className="text-2xl font-bold gradient-text cursor-pointer hover:opacity-80"
              >
                carbonX
              </motion.div>
            </Link>
          </div>

          {/* Toggle Button */}
          <button
            onClick={() => setIsSidebarOpen(!isSidebarOpen)}
            className="absolute -right-3 top-9 p-1.5 rounded-full bg-[#1E293B] border border-[#76EAD7]/20 text-[#76EAD7] hover:bg-[#76EAD7]/10 transition-colors duration-300"
          >
            <svg
              className="w-4 h-4"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d={isSidebarOpen ? "M15 19l-7-7 7-7" : "M9 5l7 7-7 7"}
              />
            </svg>
          </button>

          {/* Navigation Links */}
          <div className="flex-1 px-4 py-6 space-y-2 overflow-y-auto">
            {sidebarLinks.map((link) => (
              <motion.div
                key={link.name}
                className="w-full"
                initial={false}
              >
                <Link to={link.path}>
                  <motion.button
                    className={`w-full flex items-center px-4 py-3 rounded-xl transition-all duration-300
                      ${location.pathname === link.path
                        ? 'bg-gradient-to-r from-[#76EAD7]/20 to-[#C4FB6D]/20 text-white'
                        : 'text-[#94A3B8] hover:text-white hover:bg-white/5'
                      }`}
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                  >
                    <div className="w-5 h-5 flex items-center justify-center">
                      <svg
                        className="w-5 h-5"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d={link.icon} />
                      </svg>
                    </div>
                    <motion.div
                      initial={{ opacity: 1, width: 'auto' }}
                      animate={{ 
                        opacity: isSidebarOpen ? 1 : 0,
                        width: isSidebarOpen ? 'auto' : 0
                      }}
                      transition={{ duration: 0.2 }}
                      className="ml-4 font-medium overflow-hidden whitespace-nowrap"
                    >
                      {link.name}
                    </motion.div>
                  </motion.button>
                </Link>
              </motion.div>
            ))}
          </div>
        </motion.div>
      </AnimatePresence>

      {/* Main Content */}
      <div className="flex-1 overflow-auto">
        <div className="p-8">
          {children}
        </div>
      </div>
    </div>
  );
};

export default DashboardLayout; 