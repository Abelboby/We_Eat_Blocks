import { motion } from 'framer-motion';
import { useEffect } from 'react';

const SplashScreen = ({ onComplete }) => {
  useEffect(() => {
    // Trigger the transition after 3 seconds
    const timer = setTimeout(() => {
      onComplete();
    }, 3000);

    return () => clearTimeout(timer);
  }, [onComplete]);

  // Path animation for the X letter
  const pathVariants = {
    hidden: { pathLength: 0, opacity: 0 },
    visible: { 
      pathLength: 1, 
      opacity: 1,
      transition: { 
        duration: 1.5, 
        ease: "easeInOut",
        delay: 0.5
      }
    }
  };

  return (
    <motion.div
      className="fixed inset-0 z-50 flex items-center justify-center bg-[#0F172A]"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ 
        opacity: 0,
        transition: { duration: 0.8, ease: "easeInOut" }
      }}
    >
      {/* Animated background blobs */}
      <div className="absolute inset-0 overflow-hidden">
        <motion.div 
          className="absolute"
          animate={{
            scale: [1, 1.2, 1],
            opacity: [0.2, 0.3, 0.2],
            x: [0, 20, 0],
            y: [0, -20, 0],
          }}
          transition={{ duration: 6, repeat: Infinity, ease: "easeInOut" }}
          style={{
            top: '30%',
            left: '40%',
            width: '600px',
            height: '600px',
            borderRadius: '50%',
            background: 'radial-gradient(circle at center, rgba(118, 234, 215, 0.15), rgba(0, 0, 0, 0))',
            filter: 'blur(60px)',
          }}
        />
        <motion.div 
          className="absolute"
          animate={{
            scale: [1, 1.3, 1],
            opacity: [0.15, 0.25, 0.15],
          }}
          transition={{ duration: 7, repeat: Infinity, ease: "easeInOut" }}
          style={{
            top: '40%',
            right: '40%',
            width: '500px',
            height: '500px',
            borderRadius: '50%',
            background: 'radial-gradient(circle at center, rgba(196, 251, 109, 0.1), rgba(0, 0, 0, 0))',
            filter: 'blur(60px)',
          }}
        />
      </div>

      <div className="relative z-10">
        {/* Logo Container */}
        <motion.div
          className="flex flex-col items-center"
          initial={{ y: 30, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ duration: 1, ease: "easeOut" }}
        >
          {/* Animated Logo */}
          <div className="relative w-36 h-36 mb-2 flex items-center justify-center">
            {/* Circle background */}
            <motion.div 
              className="absolute w-full h-full rounded-full"
              initial={{ scale: 0, opacity: 0 }}
              animate={{ 
                scale: 1, 
                opacity: 0.15,
                boxShadow: [
                  "0 0 0 rgba(118, 234, 215, 0.3)",
                  "0 0 30px rgba(118, 234, 215, 0.7)",
                  "0 0 0 rgba(118, 234, 215, 0.3)"
                ]
              }}
              transition={{ 
                duration: 2.5, 
                ease: "easeOut",
                boxShadow: {
                  repeat: Infinity,
                  duration: 3
                }
              }}
              style={{
                background: 'linear-gradient(135deg, rgba(118, 234, 215, 0.2), rgba(196, 251, 109, 0.2))'
              }}
            />

            {/* X SVG icon */}
            <motion.svg 
              width="70" 
              height="70" 
              viewBox="0 0 24 24" 
              fill="none" 
              xmlns="http://www.w3.org/2000/svg"
              initial={{ rotate: -30, scale: 0.8 }}
              animate={{ rotate: 0, scale: 1 }}
              transition={{ duration: 1.2, delay: 0.3, ease: "easeOut" }}
            >
              <motion.path
                d="M18 6L6 18M6 6l12 12"
                stroke="url(#gradient)"
                strokeWidth="2"
                strokeLinecap="round"
                variants={pathVariants}
                initial="hidden"
                animate="visible"
              />
              <defs>
                <linearGradient id="gradient" x1="6" y1="6" x2="18" y2="18" gradientUnits="userSpaceOnUse">
                  <stop stopColor="#76EAD7" />
                  <stop offset="1" stopColor="#C4FB6D" />
                </linearGradient>
              </defs>
            </motion.svg>
          </div>

          {/* Logo Text */}
          <motion.h1
            className="text-5xl sm:text-6xl font-bold mb-2"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.8, ease: "easeOut" }}
          >
            <span className="gradient-text">
              carbon<span className="text-white">X</span>
            </span>
          </motion.h1>

          {/* Animated Line */}
          <motion.div
            className="h-0.5 bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] mt-2"
            initial={{ width: 0 }}
            animate={{ width: "180px" }}
            transition={{ duration: 1.2, delay: 1 }}
          />

          {/* Tagline */}
          <motion.p
            className="mt-4 text-[#94A3B8] text-lg mb-8"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8, delay: 1.2 }}
          >
            Revolutionizing Carbon Credits
          </motion.p>

          {/* Loading bar instead of dots */}
          <motion.div 
            className="w-48 h-1.5 bg-[#1E293B] rounded-full overflow-hidden"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 1.4 }}
          >
            <motion.div 
              className="h-full rounded-full bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D]"
              initial={{ width: 0 }}
              animate={{ width: "100%" }}
              transition={{ 
                duration: 2,
                delay: 1.5,
                ease: "easeInOut"
              }}
            />
          </motion.div>
        </motion.div>
      </div>
    </motion.div>
  );
};

export default SplashScreen; 