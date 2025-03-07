import { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { useWallet } from '../context/wallet_context';
import RegistrationModal from '../components/company/registration_modal';
import CompanyProfile from '../components/company/company_profile';
import ReportSubmissionModal from '../components/company/report_submission_modal';
import { getAllCompanies } from '../services/auth_service';

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
  const [showReportModal, setShowReportModal] = useState(false);
  const [isMetaMaskInstalled, setIsMetaMaskInstalled] = useState(false);
  const [verifiedCompanies, setVerifiedCompanies] = useState([]);
  const [selectedCompany, setSelectedCompany] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  
  // Check if MetaMask is installed
  useEffect(() => {
    if (window.ethereum) {
      setIsMetaMaskInstalled(true);
    }
    
    // Load verified companies on component mount
    loadVerifiedCompanies();
  }, []);
  
  // Load verified companies
  const loadVerifiedCompanies = async () => {
    try {
      setIsLoading(true);
      const result = await getAllCompanies();
      
      if (result.success) {
        // Filter only verified companies
        const verified = result.companies.filter(c => c.verificationStatus === 'approved');
        setVerifiedCompanies(verified);
      }
    } catch (error) {
      console.error("Error loading companies:", error);
    } finally {
      setIsLoading(false);
    }
  };
  
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
  
  // Handle submit report button click
  const handleSubmitReportClick = () => {
    setShowReportModal(true);
  };
  
  // Handle MetaMask installation
  const handleInstallMetaMask = () => {
    window.open('https://metamask.io/download/', '_blank');
  };
  
  // Format date
  const formatDate = (date) => {
    if (!date) return 'N/A';
    
    if (typeof date === 'string') {
      date = new Date(date);
    }
    
    return new Intl.DateTimeFormat('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    }).format(date);
  };
  
  // Format wallet address
  const formatAddress = (address) => {
    if (!address) return '0x...';
    return `${address.substring(0, 6)}...${address.substring(address.length - 4)}`;
  };
  
  // View company details
  const viewCompanyDetails = (company) => {
    setSelectedCompany(company);
  };
  
  // Clear selected company
  const clearSelectedCompany = () => {
    setSelectedCompany(null);
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
      
      {/* Your Company Profile (when logged in) */}
      {walletAddress && company && (
        <div className="mb-8">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-xl font-bold text-white flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 mr-2 text-[#76EAD7]" viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clipRule="evenodd" />
              </svg>
              Your Company Profile
            </h2>
            
            {/* Submit Sustainability Report Button */}
            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={handleSubmitReportClick}
              className="px-4 py-2 rounded-lg bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] text-[#0F172A] font-semibold flex items-center"
            >
              <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M6 2a2 2 0 00-2 2v12a2 2 0 002 2h8a2 2 0 002-2V7.414A2 2 0 0015.414 6L12 2.586A2 2 0 0010.586 2H6zm5 6a1 1 0 10-2 0v2H7a1 1 0 100 2h2v2a1 1 0 102 0v-2h2a1 1 0 100-2h-2V8z" clipRule="evenodd" />
              </svg>
              Submit Report
            </motion.button>
          </div>
          
          <CompanyProfile />
        </div>
      )}
      
      {/* All Verified Companies Section */}
      <div>
        <h2 className="text-xl font-bold text-white mb-4 flex items-center">
          <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 mr-2 text-[#76EAD7]" viewBox="0 0 20 20" fill="currentColor">
            <path d="M13 6a3 3 0 11-6 0 3 3 0 016 0zM18 8a2 2 0 11-4 0 2 2 0 014 0zM14 15a4 4 0 00-8 0v3h8v-3zM6 8a2 2 0 11-4 0 2 2 0 014 0zM16 18v-3a5.972 5.972 0 00-.75-2.906A3.005 3.005 0 0119 15v3h-3zM4.75 12.094A5.973 5.973 0 004 15v3H1v-3a3 3 0 013.75-2.906z" />
          </svg>
          Verified Companies
        </h2>
        
        {/* Selected Company Details or Companies List */}
        {selectedCompany ? (
          // Selected Company Details
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl overflow-hidden border border-[#76EAD7]/10"
          >
            {/* Header with back button */}
            <div className="p-6 border-b border-[#76EAD7]/10 flex justify-between items-center">
              <div className="flex items-center">
                <div className="w-10 h-10 bg-[#76EAD7]/10 rounded-full flex items-center justify-center mr-3">
                  <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 text-[#76EAD7]" viewBox="0 0 20 20" fill="currentColor">
                    <path fillRule="evenodd" d="M4 4a2 2 0 012-2h8a2 2 0 012 2v12a1 1 0 01-1 1h-2a1 1 0 01-1-1v-2a1 1 0 00-1-1H7a1 1 0 00-1 1v2a1 1 0 01-1 1H3a1 1 0 01-1-1V4zm3 1h2v2H7V5zm2 4H7v2h2V9zm2-4h2v2h-2V5zm2 4h-2v2h2V9z" clipRule="evenodd" />
                  </svg>
                </div>
                <div>
                  <h3 className="text-lg font-semibold text-white">{selectedCompany.name}</h3>
                  <p className="text-[#94A3B8] text-sm">{selectedCompany.industry}</p>
                </div>
              </div>
              <button 
                onClick={clearSelectedCompany}
                className="text-[#94A3B8] hover:text-white transition-colors"
              >
                <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                </svg>
              </button>
            </div>
            
            {/* Company Details */}
            <div className="p-6">
              {/* Overview */}
              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4 mb-6">
                <div className="p-4 bg-[#0F172A]/60 rounded-xl border border-[#76EAD7]/10">
                  <p className="text-[#94A3B8] text-sm">Registered</p>
                  <p className="text-white font-medium mt-1">{formatDate(selectedCompany.registrationDate)}</p>
                </div>
                <div className="p-4 bg-[#0F172A]/60 rounded-xl border border-[#76EAD7]/10">
                  <p className="text-[#94A3B8] text-sm">Website</p>
                  <p className="text-white font-medium mt-1 truncate">
                    {selectedCompany.website ? (
                      <a href={selectedCompany.website} target="_blank" rel="noopener noreferrer" className="text-[#76EAD7] hover:underline">
                        {selectedCompany.website}
                      </a>
                    ) : (
                      'N/A'
                    )}
                  </p>
                </div>
                <div className="p-4 bg-[#0F172A]/60 rounded-xl border border-[#76EAD7]/10">
                  <p className="text-[#94A3B8] text-sm">Wallet</p>
                  <p className="text-white font-medium mt-1 font-mono">{formatAddress(selectedCompany.walletAddress)}</p>
                </div>
              </div>
              
              {/* Token Balances */}
              <h4 className="text-lg font-medium text-white mb-3 mt-6">Carbon Credit Balances</h4>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                {selectedCompany.tokenBalances ? (
                  Object.entries(selectedCompany.tokenBalances).map(([token, amount]) => (
                    <div 
                      key={token}
                      className="bg-[#0F172A]/40 p-4 rounded-xl border border-[#76EAD7]/10"
                    >
                      <div className="flex justify-between items-center mb-2">
                        <span className="text-[#76EAD7] px-2 py-1 bg-[#76EAD7]/10 rounded-lg">{token}</span>
                        <div className="w-8 h-8 bg-[#76EAD7]/10 rounded-full flex items-center justify-center">
                          <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4 text-[#76EAD7]" viewBox="0 0 20 20" fill="currentColor">
                            <path d="M4 4a2 2 0 00-2 2v1h16V6a2 2 0 00-2-2H4z" />
                            <path fillRule="evenodd" d="M18 9H2v5a2 2 0 002 2h12a2 2 0 002-2V9zM4 13a1 1 0 011-1h1a1 1 0 110 2H5a1 1 0 01-1-1zm5-1a1 1 0 100 2h1a1 1 0 100-2H9z" clipRule="evenodd" />
                          </svg>
                        </div>
                      </div>
                      <div className="mt-2">
                        <p className="text-white font-medium text-lg">{amount} Tonnes</p>
                      </div>
                    </div>
                  ))
                ) : (
                  <div className="col-span-3 text-center text-[#94A3B8] p-6">
                    No token balances available
                  </div>
                )}
              </div>
              
              {/* Recent Transactions */}
              <h4 className="text-lg font-medium text-white mb-3 mt-6">Recent Transactions</h4>
              {selectedCompany.transactions && selectedCompany.transactions.length > 0 ? (
                <div className="bg-[#0F172A]/40 rounded-xl border border-[#76EAD7]/10 overflow-hidden">
                  <div className="overflow-x-auto">
                    <table className="min-w-full divide-y divide-[#76EAD7]/10">
                      <thead className="bg-[#0F172A]/60">
                        <tr>
                          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-[#94A3B8] uppercase tracking-wider">
                            Type
                          </th>
                          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-[#94A3B8] uppercase tracking-wider">
                            Amount
                          </th>
                          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-[#94A3B8] uppercase tracking-wider">
                            Date
                          </th>
                          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-[#94A3B8] uppercase tracking-wider">
                            Hash
                          </th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-[#76EAD7]/10">
                        {selectedCompany.transactions.map((tx, index) => (
                          <tr key={index} className="hover:bg-[#0F172A]/20">
                            <td className="px-6 py-4 whitespace-nowrap">
                              <div className="text-white">{tx.type}</div>
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap">
                              <div className="text-white">{tx.amount} {tx.token}</div>
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap">
                              <div className="text-white">{formatDate(tx.date)}</div>
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap">
                              <a href={`https://etherscan.io/tx/${tx.hash}`} target="_blank" rel="noopener noreferrer" className="text-[#76EAD7] hover:underline truncate max-w-[150px] inline-block">
                                {formatAddress(tx.hash)}
                              </a>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              ) : (
                <div className="text-center text-[#94A3B8] p-6 bg-[#0F172A]/40 rounded-xl border border-[#76EAD7]/10">
                  No transaction history available
                </div>
              )}
            </div>
          </motion.div>
        ) : (
          // Companies List
          <div>
            {isLoading ? (
              <div className="flex items-center justify-center py-20">
                <div className="w-12 h-12 border-4 border-[#76EAD7]/30 border-t-[#76EAD7] rounded-full animate-spin"></div>
              </div>
            ) : verifiedCompanies.length === 0 ? (
              <div className="text-center py-20 bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/10">
                <svg xmlns="http://www.w3.org/2000/svg" className="h-16 w-16 text-[#76EAD7]/30 mx-auto mb-4" viewBox="0 0 20 20" fill="currentColor">
                  <path d="M13 6a3 3 0 11-6 0 3 3 0 016 0zM18 8a2 2 0 11-4 0 2 2 0 014 0zM14 15a4 4 0 00-8 0v3h8v-3zM6 8a2 2 0 11-4 0 2 2 0 014 0zM16 18v-3a5.972 5.972 0 00-.75-2.906A3.005 3.005 0 0119 15v3h-3zM4.75 12.094A5.973 5.973 0 004 15v3H1v-3a3 3 0 013.75-2.906z" />
                </svg>
                <h3 className="text-xl font-medium text-white mb-2">No Verified Companies</h3>
                <p className="text-[#94A3B8]">There are no verified companies on the platform yet.</p>
              </div>
            ) : (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {verifiedCompanies.map(company => (
                  <motion.div
                    key={company.id}
                    whileHover={{ scale: 1.02 }}
                    className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-5 border border-[#76EAD7]/10 cursor-pointer hover:border-[#76EAD7]/30 transition-all"
                    onClick={() => viewCompanyDetails(company)}
                  >
                    <div className="flex items-start mb-4">
                      <div className="w-10 h-10 bg-[#76EAD7]/10 rounded-full flex items-center justify-center flex-shrink-0">
                        <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 text-[#76EAD7]" viewBox="0 0 20 20" fill="currentColor">
                          <path fillRule="evenodd" d="M4 4a2 2 0 012-2h8a2 2 0 012 2v12a1 1 0 01-1 1h-2a1 1 0 01-1-1v-2a1 1 0 00-1-1H7a1 1 0 00-1 1v2a1 1 0 01-1 1H3a1 1 0 01-1-1V4zm3 1h2v2H7V5zm2 4H7v2h2V9zm2-4h2v2h-2V5zm2 4h-2v2h2V9z" clipRule="evenodd" />
                        </svg>
                      </div>
                      <div className="ml-3 flex-1">
                        <h3 className="text-white font-semibold text-lg truncate">{company.name}</h3>
                        <p className="text-[#94A3B8] text-sm">{company.industry}</p>
                      </div>
                      <div className="flex-shrink-0 bg-green-500/10 px-2 py-1 rounded-full flex items-center">
                        <div className="w-2 h-2 rounded-full bg-green-400 mr-1"></div>
                        <span className="text-green-400 text-xs">Verified</span>
                      </div>
                    </div>
                    
                    <div className="grid grid-cols-2 gap-2 mt-4">
                      <div className="p-2 bg-[#0F172A]/60 rounded-lg">
                        <p className="text-[#94A3B8] text-xs">Registered</p>
                        <p className="text-white text-sm mt-1">{formatDate(company.registrationDate)}</p>
                      </div>
                      <div className="p-2 bg-[#0F172A]/60 rounded-lg">
                        <p className="text-[#94A3B8] text-xs">Token Balance</p>
                        <p className="text-white text-sm mt-1">{company.tokenBalances?.carbonCredits || 0} Tonnes</p>
                      </div>
                    </div>
                    
                    <div className="mt-4 flex justify-end">
                      <button className="text-[#76EAD7] text-sm hover:text-white transition-colors flex items-center">
                        View Details
                        <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4 ml-1" viewBox="0 0 20 20" fill="currentColor">
                          <path fillRule="evenodd" d="M12.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-2.293-2.293a1 1 0 010-1.414z" clipRule="evenodd" />
                        </svg>
                      </button>
                    </div>
                  </motion.div>
                ))}
              </div>
            )}
          </div>
        )}
      </div>
      
      {/* Registration Modal */}
      <RegistrationModal 
        isOpen={showRegModal}
        onClose={() => setShowRegModal(false)}
      />
      
      {/* Report Submission Modal */}
      <ReportSubmissionModal
        isOpen={showReportModal}
        onClose={() => setShowReportModal(false)}
      />
    </div>
  );
};

export default Companies; 