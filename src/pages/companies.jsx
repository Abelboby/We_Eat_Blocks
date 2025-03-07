import { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { useWallet } from '../context/wallet_context';
import RegistrationModal from '../components/company/registration_modal';
import CompanyProfile from '../components/company/company_profile';

const Companies = () => {
  const { 
    walletAddress, 
    isConnecting,
    connectionError,
    company,
    connect,
    disconnect
  } = useWallet();
  
  const [showRegModal, setShowRegModal] = useState(false);
  const [isMetaMaskInstalled, setIsMetaMaskInstalled] = useState(false);
  
  // Check if MetaMask is installed
  useEffect(() => {
    if (window.ethereum) {
      setIsMetaMaskInstalled(true);
    }
  }, []);
  
  // Handle wallet connection
  const handleConnectWallet = async () => {
    if (walletAddress) {
      disconnect();
    } else {
      await connect();
    }
  };
  
  // Handle login/register button click
  const handleLoginClick = () => {
    if (!walletAddress) {
      // Need to connect wallet first
      return;
    }
    
    if (!company) {
      // Company is not registered, show registration modal
      setShowRegModal(true);
    }
    // If company exists, profile is already shown
  };
  
  // Handle MetaMask installation
  const handleInstallMetaMask = () => {
    window.open('https://metamask.io/download/', '_blank');
  };
  
  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-8">
        <div>
          <h1 className="text-2xl font-bold text-white mb-2">Companies</h1>
          <p className="text-[#94A3B8]">Register your company and manage carbon credits</p>
        </div>
        
        <div className="flex flex-col sm:flex-row gap-4 mt-4 md:mt-0">
          {/* Connect Wallet Button */}
          {isMetaMaskInstalled ? (
            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={handleConnectWallet}
              className={`px-4 py-2 rounded-lg border flex items-center ${
                walletAddress 
                  ? 'border-[#76EAD7]/40 bg-[#76EAD7]/10 text-white' 
                  : 'border-[#76EAD7] bg-[#76EAD7] text-[#0F172A]'
              }`}
              disabled={isConnecting}
            >
              {isConnecting ? (
                <>
                  <div className="mr-2 w-4 h-4 border-2 border-[#0F172A]/30 border-t-[#0F172A] rounded-full animate-spin"></div>
                  <span>Connecting...</span>
                </>
              ) : walletAddress ? (
                <>
                  <img src="/src/assets/metamask.png" alt="MetaMask" className="w-5 h-5 mr-2" />
                  <span className="font-mono text-sm truncate max-w-[100px]">
                    {walletAddress.substring(0, 6)}...{walletAddress.substring(walletAddress.length - 4)}
                  </span>
                </>
              ) : (
                <>
                  <img src="/src/assets/metamask.png" alt="MetaMask" className="w-5 h-5 mr-2" />
                  <span>Connect MetaMask</span>
                </>
              )}
            </motion.button>
          ) : (
            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={handleInstallMetaMask}
              className="px-4 py-2 rounded-lg border border-orange-500 bg-orange-500/10 text-white flex items-center"
            >
              <img src="/src/assets/metamask.png" alt="MetaMask" className="w-5 h-5 mr-2" />
              <span>Install MetaMask</span>
            </motion.button>
          )}
          
          {/* Login/Register Button - Only enabled when wallet is connected */}
          <motion.button
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            onClick={handleLoginClick}
            className={`px-4 py-2 rounded-lg flex items-center justify-center ${
              !walletAddress 
                ? 'bg-[#1E293B]/50 text-[#94A3B8] cursor-not-allowed' 
                : company 
                  ? 'bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] text-[#0F172A] font-semibold' 
                  : 'bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] text-[#0F172A] font-semibold'
            }`}
            disabled={!walletAddress}
          >
            <span className="mr-2">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M18 8a6 6 0 01-7.743 5.743L10 14l-1 1-1 1H6v-1l1-1 1-1-.257-.257A6 6 0 1118 8zm-6-4a1 1 0 10-2 0v1H8a1 1 0 00-2 0v1H4a1 1 0 00-1 1v3a1 1 0 001 1h1v1a1 1 0 102 0v1h2a1 1 0 100-2h-1V8a1 1 0 00-1-1H4V6h2v1a1 1 0 102 0V6h2v1a1 1 0 102 0V6h2V4h-1V3z" clipRule="evenodd" />
              </svg>
            </span>
            {!walletAddress ? (
              'Connect Wallet to Log In'
            ) : company ? (
              'Logged In'
            ) : (
              'Register Company'
            )}
          </motion.button>
        </div>
      </div>
      
      {/* Connection Error */}
      {connectionError && (
        <div className="mb-6 p-4 bg-red-500/10 border border-red-500/20 rounded-lg">
          <p className="text-red-400">{connectionError}</p>
        </div>
      )}
      
      {/* Main Content */}
      <div>
        {!isMetaMaskInstalled ? (
          // MetaMask not installed
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10 text-center"
          >
            <div className="w-20 h-20 mx-auto rounded-full flex items-center justify-center mb-6">
              <img src="/src/assets/metamask.png" alt="MetaMask" className="w-16 h-16" />
            </div>
            <h2 className="text-xl font-bold text-white mb-2">MetaMask Required</h2>
            <p className="text-[#94A3B8] max-w-md mx-auto mb-6">
              To use the Companies feature, you need to install the MetaMask browser extension for secure wallet connection.
            </p>
            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={handleInstallMetaMask}
              className="px-6 py-3 bg-orange-500 text-white font-semibold rounded-lg hover:shadow-lg transition-all flex items-center mx-auto"
            >
              <img src="/src/assets/metamask.png" alt="MetaMask" className="w-5 h-5 mr-2" />
              <span>Install MetaMask</span>
            </motion.button>
          </motion.div>
        ) : !walletAddress ? (
          // Not connected state
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10 text-center"
          >
            <div className="w-20 h-20 mx-auto rounded-full flex items-center justify-center mb-6">
              <img src="/src/assets/metamask.png" alt="MetaMask" className="w-16 h-16" />
            </div>
            <h2 className="text-xl font-bold text-white mb-2">Connect MetaMask</h2>
            <p className="text-[#94A3B8] max-w-md mx-auto mb-6">
              Connect your MetaMask wallet to log in or register your company for carbon credit trading.
            </p>
            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={handleConnectWallet}
              className="px-6 py-3 bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] text-[#0F172A] font-semibold rounded-lg hover:shadow-lg transition-all flex items-center mx-auto"
            >
              <img src="/src/assets/metamask.png" alt="MetaMask" className="w-5 h-5 mr-2" />
              <span>Connect MetaMask</span>
            </motion.button>
          </motion.div>
        ) : !company ? (
          // Connected but not registered
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10 text-center"
          >
            <div className="w-20 h-20 mx-auto bg-[#76EAD7]/10 rounded-full flex items-center justify-center mb-6">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-10 w-10 text-[#76EAD7]" viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M6 6V5a3 3 0 013-3h2a3 3 0 013 3v1h2a2 2 0 012 2v3.57A22.952 22.952 0 0110 13a22.95 22.95 0 01-8-1.43V8a2 2 0 012-2h2zm2-1a1 1 0 011-1h2a1 1 0 011 1v1H8V5zm1 5a1 1 0 011-1h.01a1 1 0 110 2H10a1 1 0 01-1-1z" clipRule="evenodd" />
                <path d="M2 13.692V16a2 2 0 002 2h12a2 2 0 002-2v-2.308A24.974 24.974 0 0110 15c-2.796 0-5.487-.46-8-1.308z" />
              </svg>
            </div>
            <h2 className="text-xl font-bold text-white mb-2">Register Your Company</h2>
            <p className="text-[#94A3B8] max-w-md mx-auto mb-6">
              Your MetaMask wallet is connected, but you need to register your company to start trading carbon credits.
            </p>
            <div className="bg-[#0F172A]/60 rounded-lg p-3 mb-6 max-w-md mx-auto text-left">
              <div className="flex items-center">
                <img src="/src/assets/metamask.png" alt="MetaMask" className="w-6 h-6 mr-3" />
                <div>
                  <p className="text-white text-sm font-medium">Connected Address:</p>
                  <p className="text-[#94A3B8] text-xs font-mono">{walletAddress}</p>
                </div>
              </div>
            </div>
            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={() => setShowRegModal(true)}
              className="px-6 py-3 bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] text-[#0F172A] font-semibold rounded-lg hover:shadow-lg transition-all"
            >
              Register Now
            </motion.button>
          </motion.div>
        ) : (
          // Connected and registered - Show company profile
          <CompanyProfile />
        )}
      </div>
      
      {/* Registration Modal */}
      <RegistrationModal 
        isOpen={showRegModal}
        onClose={() => setShowRegModal(false)}
      />
    </div>
  );
};

export default Companies; 