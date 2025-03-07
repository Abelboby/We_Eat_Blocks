import { useState } from 'react';
import { motion } from 'framer-motion';
import { verifyReport } from '../../services/carbon_contract_service';
import metamaskIcon from '../../assets/metamask.png';

const ReportVerificationCard = ({ report, index, onVerify }) => {
  const [tokensToMint, setTokensToMint] = useState(1);
  const [isVerifying, setIsVerifying] = useState(false);
  const [error, setError] = useState(null);
  
  // Format timestamp to readable date
  const formatDate = (timestamp) => {
    if (!timestamp) return 'Unknown';
    const date = new Date(Number(timestamp) * 1000);
    return new Intl.DateTimeFormat('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    }).format(date);
  };
  
  // Format address
  const formatAddress = (address) => {
    if (!address) return '0x...';
    return `${address.substring(0, 6)}...${address.substring(address.length - 4)}`;
  };
  
  // Handle report verification
  const handleVerify = async () => {
    try {
      setIsVerifying(true);
      setError(null);
      
      // Ensure tokensToMint is a valid integer
      const tokenAmount = Math.floor(Number(tokensToMint));
      
      if (isNaN(tokenAmount) || tokenAmount <= 0) {
        setError('Please enter a valid positive number of tokens to mint');
        setIsVerifying(false);
        return;
      }
      
      console.log(`Verifying report at index ${index} with ${tokenAmount} tokens`);
      const result = await verifyReport(index, tokenAmount);
      
      if (result.success) {
        // Update parent component
        onVerify(index, tokenAmount);
      } else {
        setError(result.error);
      }
    } catch (error) {
      console.error('Verification error:', error);
      setError(error.message || 'An error occurred while verifying the report');
    } finally {
      setIsVerifying(false);
    }
  };
  
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4 }}
      className="feature-card-enhanced bg-[#1E293B]/70 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/20 mb-6 overflow-hidden relative"
    >
      {/* Glowing effect */}
      <div className="absolute top-0 left-0 w-full h-full bg-gradient-to-br from-[#76EAD7]/5 to-[#C4FB6D]/5 opacity-30 pointer-events-none"></div>
      
      {/* Report Header */}
      <div className="flex flex-col md:flex-row justify-between mb-6">
        <div className="flex items-center mb-4 md:mb-0">
          <div className="feature-icon-enhanced w-12 h-12 bg-[#0F172A] rounded-full flex items-center justify-center flex-shrink-0 border border-[#76EAD7]/30">
            <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6 text-[#76EAD7]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
          </div>
          <div className="ml-4">
            <h3 className="text-xl font-bold text-white gradient-text">{report.title || 'Untitled Report'}</h3>
            <div className="flex flex-wrap items-center mt-1">
              <span className="bg-[#76EAD7]/10 text-[#76EAD7] rounded-full px-3 py-1 text-sm mr-2 mb-1">
                {report.category || 'Uncategorized'}
              </span>
              <span className="text-[#94A3B8] text-sm mb-1">
                Submitted: {formatDate(report.timestamp)}
              </span>
            </div>
          </div>
        </div>
        
        <div className="flex items-center">
          <span className="bg-yellow-500/10 text-yellow-400 rounded-full px-3 py-1 text-sm flex items-center">
            <div className="w-2 h-2 rounded-full bg-yellow-400 mr-2"></div>
            Pending Verification
          </span>
        </div>
      </div>
      
      {/* Report Content */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
        <div className="lg:col-span-2">
          <div className="bg-[#0F172A]/60 rounded-xl p-4">
            <h4 className="text-[#76EAD7] font-medium mb-2">Description</h4>
            <p className="text-white">{report.description || 'No description provided.'}</p>
          </div>
        </div>
        
        <div>
          <div className="bg-[#0F172A]/60 rounded-xl p-4">
            <h4 className="text-[#76EAD7] font-medium mb-2">Reporter</h4>
            <div className="flex items-center">
              <img src={metamaskIcon} alt="MetaMask" className="w-5 h-5 mr-2" />
              <a 
                href={`https://etherscan.io/address/${report.reporter}`}
                target="_blank" 
                rel="noopener noreferrer"
                className="text-white hover:text-[#76EAD7] transition-colors font-mono"
              >
                {formatAddress(report.reporter)}
              </a>
            </div>
          </div>
        </div>
      </div>
      
      {/* Location */}
      <div className="bg-[#0F172A]/60 rounded-xl p-4 mb-6">
        <h4 className="text-[#76EAD7] font-medium mb-2">Location</h4>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="flex items-center">
            <div className="w-8 h-8 rounded-full bg-[#76EAD7]/10 flex items-center justify-center mr-3">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4 text-[#76EAD7]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
            </div>
            <div>
              <span className="text-[#94A3B8] text-sm">Latitude</span>
              <p className="text-white font-medium">
                {report.latitude ? (parseFloat(report.latitude) / 100).toFixed(2) : '0.00'}° {report.latDirection || 'N'}
              </p>
            </div>
          </div>
          <div className="flex items-center">
            <div className="w-8 h-8 rounded-full bg-[#76EAD7]/10 flex items-center justify-center mr-3">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4 text-[#76EAD7]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7" />
              </svg>
            </div>
            <div>
              <span className="text-[#94A3B8] text-sm">Longitude</span>
              <p className="text-white font-medium">
                {report.longitude ? (parseFloat(report.longitude) / 100).toFixed(2) : '0.00'}° {report.longDirection || 'E'}
              </p>
            </div>
          </div>
        </div>
        
        <div className="mt-4 bg-[#0F172A]/40 rounded-lg p-3 border border-[#76EAD7]/10">
          <div className="flex items-center text-[#94A3B8] text-sm">
            <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4 mr-2 text-[#76EAD7]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <span>Coordinates shown are approximate and may not be exact</span>
          </div>
        </div>
      </div>
      
      {/* Evidence */}
      {report.evidenceLink && (
        <div className="bg-[#0F172A]/60 rounded-xl p-4 mb-6">
          <h4 className="text-[#76EAD7] font-medium mb-2">Evidence</h4>
          <a 
            href={report.evidenceLink} 
            target="_blank" 
            rel="noopener noreferrer"
            className="text-white hover:text-[#76EAD7] transition-colors flex items-center"
          >
            <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
            </svg>
            View Evidence
          </a>
        </div>
      )}
      
      {/* Verification Form */}
      <div className="bg-[#0F172A]/60 rounded-xl p-4 border border-[#76EAD7]/20">
        <h4 className="text-[#76EAD7] font-medium mb-4">Verify Report</h4>
        
        {error && (
          <div className="mb-4 p-3 bg-red-500/10 border border-red-500/30 rounded-lg">
            <div className="flex items-start">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 text-red-400 mr-2 flex-shrink-0 mt-0.5" viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
              </svg>
              <p className="text-red-400 text-sm">{error}</p>
            </div>
          </div>
        )}
        
        <div className="flex flex-col md:flex-row items-end gap-4">
          <div className="flex-1">
            <label className="block text-[#94A3B8] text-sm mb-2">
              Tokens to Mint (Carbon Credits)
            </label>
            <div className={`relative rounded-lg border ${error ? 'border-red-500/50' : 'border-[#76EAD7]/30'} focus-within:ring-2 focus-within:ring-[#76EAD7]/50 bg-[#0F172A]`}>
              <input
                type="number"
                min="1"
                step="1"
                value={tokensToMint}
                onChange={(e) => setTokensToMint(Math.max(1, parseInt(e.target.value) || 1))}
                className="w-full rounded-lg px-4 py-2 text-white bg-transparent focus:outline-none"
                placeholder="Enter amount of tokens"
              />
            </div>
            <p className="text-xs text-[#94A3B8] mt-1">Must be a whole number greater than 0</p>
          </div>
          <motion.button
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            onClick={handleVerify}
            disabled={isVerifying}
            className="px-6 py-3 rounded-lg bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] text-[#0F172A] font-semibold hover:shadow-lg transition-all flex items-center justify-center md:w-auto w-full disabled:opacity-70 disabled:cursor-not-allowed"
          >
            {isVerifying ? (
              <>
                <div className="mr-2 w-4 h-4 border-2 border-[#0F172A]/30 border-t-[#0F172A] rounded-full animate-spin"></div>
                <span>Verifying...</span>
              </>
            ) : (
              <>
                <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor">
                  <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                </svg>
                <span>Verify & Mint Tokens</span>
              </>
            )}
          </motion.button>
        </div>
      </div>
    </motion.div>
  );
};

export default ReportVerificationCard; 