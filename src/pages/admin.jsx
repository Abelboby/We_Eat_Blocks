import { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { connectWallet } from '../services/auth_service';
import { isAdmin, getPendingCompanies, getAllCompanies } from '../services/auth_service';
import { getPendingReports } from '../services/carbon_contract_service';
import CompanyVerificationCard from '../components/admin/company_verification_card';
import ReportVerificationCard from '../components/admin/report_verification_card';
import Toast from '../components/ui/toast';
import metamaskIcon from '../assets/metamask.png';

const Admin = () => {
  const [walletAddress, setWalletAddress] = useState(null);
  const [isConnecting, setIsConnecting] = useState(false);
  const [connectionError, setConnectionError] = useState(null);
  const [isAdminUser, setIsAdminUser] = useState(false);
  
  const [toast, setToast] = useState(null);
  const [companies, setCompanies] = useState([]);
  const [pendingCompanies, setPendingCompanies] = useState([]);
  const [approvedCompanies, setApprovedCompanies] = useState([]);
  const [rejectedCompanies, setRejectedCompanies] = useState([]);
  const [pendingReports, setPendingReports] = useState([]);
  const [activeTab, setActiveTab] = useState('pending');
  const [isLoading, setIsLoading] = useState(false);
  const [isLoadingReports, setIsLoadingReports] = useState(false);
  
  // Connect wallet function
  const handleConnectWallet = async () => {
    try {
      setIsConnecting(true);
      setConnectionError(null);
      
      const result = await connectWallet();
      
      if (result.success) {
        setWalletAddress(result.address);
        
        const adminCheck = isAdmin(result.address);
        setIsAdminUser(adminCheck);
        
        if (!adminCheck) {
          setToast({
            type: 'error',
            message: 'Access denied. You are not authorized to access the admin panel.'
          });
        } else {
          loadCompaniesData();
          loadPendingReports();
        }
      } else {
        setConnectionError(result.error);
      }
    } catch (error) {
      setConnectionError(error.message);
    } finally {
      setIsConnecting(false);
    }
  };
  
  // Disconnect wallet
  const handleDisconnect = () => {
    setWalletAddress(null);
    setIsAdminUser(false);
    setPendingReports([]);
  };
  
  // Load companies data
  const loadCompaniesData = async () => {
    try {
      setIsLoading(true);
      
      // Get all companies
      const allResult = await getAllCompanies();
      
      if (allResult.success) {
        setCompanies(allResult.companies);
        
        // Filter companies by status
        setPendingCompanies(allResult.companies.filter(company => company.verificationStatus === 'pending'));
        setApprovedCompanies(allResult.companies.filter(company => company.verificationStatus === 'approved'));
        setRejectedCompanies(allResult.companies.filter(company => company.verificationStatus === 'rejected'));
      }
    } catch (error) {
      console.error("Error loading companies:", error);
    } finally {
      setIsLoading(false);
    }
  };
  
  // Load pending reports
  const loadPendingReports = async () => {
    try {
      setIsLoadingReports(true);
      
      const result = await getPendingReports();
      
      if (result.success) {
        setPendingReports(result.reports);
      } else {
        console.error("Error fetching pending reports:", result.error);
      }
    } catch (error) {
      console.error("Error loading pending reports:", error);
    } finally {
      setIsLoadingReports(false);
    }
  };
  
  // Handle company status change
  const handleCompanyStatusChange = (companyId, status) => {
    // Update companies lists
    const updatedCompanies = companies.map(company => {
      if (company.id === companyId) {
        return {
          ...company,
          verificationStatus: status,
          isVerified: status === 'approved'
        };
      }
      return company;
    });
    
    setCompanies(updatedCompanies);
    setPendingCompanies(updatedCompanies.filter(company => company.verificationStatus === 'pending'));
    setApprovedCompanies(updatedCompanies.filter(company => company.verificationStatus === 'approved'));
    setRejectedCompanies(updatedCompanies.filter(company => company.verificationStatus === 'rejected'));
    
    setToast({
      type: status === 'approved' ? 'success' : 'warning',
      message: status === 'approved' 
        ? 'Company has been approved successfully.'
        : 'Company has been rejected.'
    });
  };
  
  // Handle report verification
  const handleReportVerification = (reportIndex, tokensMinted) => {
    // Remove the verified report from the list
    const updatedReports = pendingReports.filter((_, index) => index !== reportIndex);
    setPendingReports(updatedReports);
    
    setToast({
      type: 'success',
      message: `Report verified successfully. ${tokensMinted} carbon credit tokens minted.`
    });
    
    // Refresh the reports list after a short delay
    setTimeout(() => {
      loadPendingReports();
    }, 3000);
  };
  
  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-8">
        <div>
          <h1 className="text-2xl font-bold text-white mb-2">Admin Panel</h1>
          <p className="text-[#94A3B8]">Manage company verification requests and sustainability reports</p>
        </div>
        
        <div className="mt-4 md:mt-0">
          {walletAddress ? (
            <div className="flex flex-col sm:flex-row gap-4">
              <div className="bg-[#0F172A]/80 px-4 py-2 rounded-xl border border-[#76EAD7]/10 flex items-center">
              <img src={metamaskIcon} alt="MetaMask" className="w-5 h-5 mr-2" />
                <span className="text-white text-sm font-mono truncate max-w-[150px]">
                  {walletAddress.substring(0, 6)}...{walletAddress.substring(walletAddress.length - 4)}
                </span>
                <div className="w-2 h-2 rounded-full bg-green-400 ml-2"></div>
              </div>
              
              <motion.button
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                onClick={handleDisconnect}
                className="px-4 py-2 border border-[#76EAD7]/40 rounded-lg text-[#76EAD7] hover:bg-[#76EAD7]/10 transition-colors"
              >
                Disconnect
              </motion.button>
            </div>
          ) : (
            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={handleConnectWallet}
              className="px-4 py-2 bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] text-[#0F172A] font-semibold rounded-lg hover:shadow-lg transition-all flex items-center"
              disabled={isConnecting}
            >
              {isConnecting ? (
                <>
                  <div className="mr-2 w-4 h-4 border-2 border-[#0F172A]/30 border-t-[#0F172A] rounded-full animate-spin"></div>
                  <span>Connecting...</span>
                </>
              ) : (
                <>
              <img src={metamaskIcon} alt="MetaMask" className="w-5 h-5 mr-2" />
              <span>Connect MetaMask</span>
                </>
              )}
            </motion.button>
          )}
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
        {!walletAddress ? (
          // Not connected state
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10 text-center"
          >
            <div className="w-20 h-20 mx-auto bg-[#76EAD7]/10 rounded-full flex items-center justify-center mb-6">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-10 w-10 text-[#76EAD7]" viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M5.5 2a3.5 3.5 0 101.665 6.58L8.585 10l-1.42 1.42a3.5 3.5 0 101.414 1.414L10 11.414l1.42 1.42a3.5 3.5 0 101.414-1.414L11.414 10l1.42-1.42A3.5 3.5 0 1011.5 7H11v-.5A3.5 3.5 0 007.5 3H7v-.5A3.5 3.5 0 005.5 2zM8 7a1 1 0 100-2 1 1 0 000 2zm0 2a1 1 0 100-2 1 1 0 000 2zm3 3a1 1 0 11-2 0 1 1 0 012 0zm-7 4a1 1 0 100-2 1 1 0 000 2z" clipRule="evenodd" />
              </svg>
            </div>
            <h2 className="text-xl font-bold text-white mb-2">Admin Authentication Required</h2>
            <p className="text-[#94A3B8] max-w-md mx-auto mb-6">
              Connect your MetaMask wallet to access the admin panel. Only authorized wallets can manage company verification.
            </p>
            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={handleConnectWallet}
              className="px-6 py-3 bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] text-[#0F172A] font-semibold rounded-lg hover:shadow-lg transition-all"
            >
              Connect Admin Wallet
            </motion.button>
          </motion.div>
        ) : !isAdminUser ? (
          // Connected but not admin
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10 text-center"
          >
            <div className="w-20 h-20 mx-auto bg-red-500/10 rounded-full flex items-center justify-center mb-6">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-10 w-10 text-red-400" viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M13.477 14.89A6 6 0 015.11 6.524l8.367 8.368zm1.414-1.414L6.524 5.11a6 6 0 018.367 8.367zM18 10a8 8 0 11-16 0 8 8 0 0116 0z" clipRule="evenodd" />
              </svg>
            </div>
            <h2 className="text-xl font-bold text-white mb-2">Access Denied</h2>
            <p className="text-[#94A3B8] max-w-md mx-auto mb-6">
              You don't have permission to access the admin panel. Please connect with an authorized admin wallet.
            </p>
            <div className="bg-[#0F172A]/60 rounded-lg p-3 mb-6 max-w-md mx-auto text-left">
              <div className="flex items-center">
              <img src={metamaskIcon} alt="MetaMask" className="w-5 h-5 mr-2" />
                <div>
                  <p className="text-white text-sm font-medium">Connected Address:</p>
                  <p className="text-[#94A3B8] text-xs font-mono">{walletAddress}</p>
                </div>
              </div>
            </div>
            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={handleDisconnect}
              className="px-6 py-3 border border-[#76EAD7]/40 text-[#76EAD7] font-semibold rounded-lg hover:bg-[#76EAD7]/10 transition-colors"
            >
              Disconnect
            </motion.button>
          </motion.div>
        ) : (
          // Admin dashboard
          <div>
            {/* Tabs */}
            <div className="border-b border-[#76EAD7]/10 mb-6">
              <nav className="flex space-x-8 overflow-x-auto scrollbar-hide">
                <button
                  onClick={() => setActiveTab('pending')}
                  className={`py-3 px-1 border-b-2 font-medium text-sm flex items-center whitespace-nowrap ${
                    activeTab === 'pending'
                      ? 'border-[#76EAD7] text-[#76EAD7]'
                      : 'border-transparent text-[#94A3B8] hover:text-white'
                  }`}
                >
                  <span>Pending Companies</span>
                  {pendingCompanies.length > 0 && (
                    <span className="ml-2 px-2 py-0.5 bg-yellow-500/20 text-yellow-400 rounded-full text-xs">
                      {pendingCompanies.length}
                    </span>
                  )}
                </button>
                
                <button
                  onClick={() => setActiveTab('approved')}
                  className={`py-3 px-1 border-b-2 font-medium text-sm flex items-center whitespace-nowrap ${
                    activeTab === 'approved'
                      ? 'border-[#76EAD7] text-[#76EAD7]'
                      : 'border-transparent text-[#94A3B8] hover:text-white'
                  }`}
                >
                  <span>Approved Companies</span>
                  {approvedCompanies.length > 0 && (
                    <span className="ml-2 px-2 py-0.5 bg-green-500/20 text-green-400 rounded-full text-xs">
                      {approvedCompanies.length}
                    </span>
                  )}
                </button>
                
                <button
                  onClick={() => setActiveTab('rejected')}
                  className={`py-3 px-1 border-b-2 font-medium text-sm flex items-center whitespace-nowrap ${
                    activeTab === 'rejected'
                      ? 'border-[#76EAD7] text-[#76EAD7]'
                      : 'border-transparent text-[#94A3B8] hover:text-white'
                  }`}
                >
                  <span>Rejected Companies</span>
                  {rejectedCompanies.length > 0 && (
                    <span className="ml-2 px-2 py-0.5 bg-red-500/20 text-red-400 rounded-full text-xs">
                      {rejectedCompanies.length}
                    </span>
                  )}
                </button>
                
                <button
                  onClick={() => setActiveTab('reports')}
                  className={`py-3 px-1 border-b-2 font-medium text-sm flex items-center whitespace-nowrap ${
                    activeTab === 'reports'
                      ? 'border-[#76EAD7] text-[#76EAD7]'
                      : 'border-transparent text-[#94A3B8] hover:text-white'
                  }`}
                >
                  <span>Sustainability Reports</span>
                  {pendingReports.length > 0 && (
                    <span className="ml-2 px-2 py-0.5 bg-blue-500/20 text-blue-400 rounded-full text-xs">
                      {pendingReports.length}
                    </span>
                  )}
                </button>
              </nav>
            </div>
            
            {/* Loading state */}
            {(isLoading && activeTab !== 'reports') || (isLoadingReports && activeTab === 'reports') ? (
              <div className="flex items-center justify-center py-20">
                <div className="w-12 h-12 border-4 border-[#76EAD7]/30 border-t-[#76EAD7] rounded-full animate-spin"></div>
              </div>
            ) : (
              <>
                {/* Pending Tab */}
                {activeTab === 'pending' && (
                  <div>
                    {pendingCompanies.length === 0 ? (
                      <div className="text-center py-20 bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/10">
                        <svg xmlns="http://www.w3.org/2000/svg" className="h-16 w-16 text-[#76EAD7]/30 mx-auto mb-4" viewBox="0 0 20 20" fill="currentColor">
                          <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clipRule="evenodd" />
                        </svg>
                        <h3 className="text-xl font-medium text-white mb-2">No Pending Requests</h3>
                        <p className="text-[#94A3B8]">All company verification requests have been processed.</p>
                      </div>
                    ) : (
                      pendingCompanies.map(company => (
                        <CompanyVerificationCard
                          key={company.id}
                          company={company}
                          onStatusChange={handleCompanyStatusChange}
                        />
                      ))
                    )}
                  </div>
                )}
                
                {/* Approved Tab */}
                {activeTab === 'approved' && (
                  <div>
                    {approvedCompanies.length === 0 ? (
                      <div className="text-center py-20 bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/10">
                        <svg xmlns="http://www.w3.org/2000/svg" className="h-16 w-16 text-[#76EAD7]/30 mx-auto mb-4" viewBox="0 0 20 20" fill="currentColor">
                          <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                        </svg>
                        <h3 className="text-xl font-medium text-white mb-2">No Approved Companies</h3>
                        <p className="text-[#94A3B8]">You haven't approved any company registrations yet.</p>
                      </div>
                    ) : (
                      approvedCompanies.map(company => (
                        <CompanyVerificationCard
                          key={company.id}
                          company={company}
                          onStatusChange={handleCompanyStatusChange}
                        />
                      ))
                    )}
                  </div>
                )}
                
                {/* Rejected Tab */}
                {activeTab === 'rejected' && (
                  <div>
                    {rejectedCompanies.length === 0 ? (
                      <div className="text-center py-20 bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/10">
                        <svg xmlns="http://www.w3.org/2000/svg" className="h-16 w-16 text-[#76EAD7]/30 mx-auto mb-4" viewBox="0 0 20 20" fill="currentColor">
                          <path fillRule="evenodd" d="M13.477 14.89A6 6 0 015.11 6.524l8.367 8.368zm1.414-1.414L6.524 5.11a6 6 0 018.367 8.367zM18 10a8 8 0 11-16 0 8 8 0 0116 0z" clipRule="evenodd" />
                        </svg>
                        <h3 className="text-xl font-medium text-white mb-2">No Rejected Companies</h3>
                        <p className="text-[#94A3B8]">You haven't rejected any company registrations.</p>
                      </div>
                    ) : (
                      rejectedCompanies.map(company => (
                        <CompanyVerificationCard
                          key={company.id}
                          company={company}
                          onStatusChange={handleCompanyStatusChange}
                        />
                      ))
                    )}
                  </div>
                )}
                
                {/* Reports Tab */}
                {activeTab === 'reports' && (
                  <div>
                    <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-6">
                      <div>
                        <h2 className="text-xl font-bold text-white gradient-text">Sustainability Reports</h2>
                        <p className="text-[#94A3B8]">Review and verify company sustainability reports</p>
                      </div>
                      <motion.button
                        whileHover={{ scale: 1.02 }}
                        whileTap={{ scale: 0.98 }}
                        onClick={loadPendingReports}
                        className="px-4 py-2 rounded-lg bg-[#76EAD7]/10 text-[#76EAD7] border border-[#76EAD7]/30 flex items-center hover:bg-[#76EAD7]/20 transition-colors"
                      >
                        <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor">
                          <path fillRule="evenodd" d="M4 2a1 1 0 011 1v2.101a7.002 7.002 0 0111.601 2.566 1 1 0 11-1.885.666A5.002 5.002 0 005.999 7H9a1 1 0 010 2H4a1 1 0 01-1-1V3a1 1 0 011-1zm.008 9.057a1 1 0 011.276.61A5.002 5.002 0 0014.001 13H11a1 1 0 110-2h5a1 1 0 011 1v5a1 1 0 11-2 0v-2.101a7.002 7.002 0 01-11.601-2.566 1 1 0 01.61-1.276z" clipRule="evenodd" />
                        </svg>
                        Refresh Reports
                      </motion.button>
                    </div>
                    
                    {/* Stats Cards */}
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                      <div className="stats-card bg-[#0F172A]/80 p-5 rounded-xl border border-[#76EAD7]/20">
                        <div className="flex items-center mb-3">
                          <div className="w-10 h-10 bg-[#76EAD7]/10 rounded-full flex items-center justify-center mr-3">
                            <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 text-[#76EAD7]" viewBox="0 0 20 20" fill="currentColor">
                              <path d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z" />
                              <path fillRule="evenodd" d="M4 5a2 2 0 012-2 3 3 0 003 3h2a3 3 0 003-3 2 2 0 012 2v11a2 2 0 01-2 2H6a2 2 0 01-2-2V5zm3 4a1 1 0 000 2h.01a1 1 0 100-2H7zm3 0a1 1 0 000 2h3a1 1 0 100-2h-3zm-3 4a1 1 0 100 2h.01a1 1 0 100-2H7zm3 0a1 1 0 100 2h3a1 1 0 100-2h-3z" clipRule="evenodd" />
                            </svg>
                          </div>
                          <p className="text-[#94A3B8]">Pending Reports</p>
                        </div>
                        <h3 className="text-3xl font-bold text-white">{pendingReports.length}</h3>
                      </div>
                      
                      <div className="stats-card bg-[#0F172A]/80 p-5 rounded-xl border border-[#76EAD7]/20">
                        <div className="flex items-center mb-3">
                          <div className="w-10 h-10 bg-[#76EAD7]/10 rounded-full flex items-center justify-center mr-3">
                            <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 text-[#76EAD7]" viewBox="0 0 20 20" fill="currentColor">
                              <path d="M4 4a2 2 0 00-2 2v1h16V6a2 2 0 00-2-2H4z" />
                              <path fillRule="evenodd" d="M18 9H2v5a2 2 0 002 2h12a2 2 0 002-2V9zM4 13a1 1 0 011-1h1a1 1 0 110 2H5a1 1 0 01-1-1zm5-1a1 1 0 100 2h1a1 1 0 100-2H9z" clipRule="evenodd" />
                            </svg>
                          </div>
                          <p className="text-[#94A3B8]">Mintable Credits</p>
                        </div>
                        <h3 className="text-3xl font-bold text-white">{pendingReports.length > 0 ? `${pendingReports.length * 10}+` : '0'}</h3>
                      </div>
                      
                      <div className="stats-card bg-[#0F172A]/80 p-5 rounded-xl border border-[#76EAD7]/20">
                        <div className="flex items-center mb-3">
                          <div className="w-10 h-10 bg-[#76EAD7]/10 rounded-full flex items-center justify-center mr-3">
                            <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 text-[#76EAD7]" viewBox="0 0 20 20" fill="currentColor">
                              <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clipRule="evenodd" />
                            </svg>
                          </div>
                          <p className="text-[#94A3B8]">Avg. Processing Time</p>
                        </div>
                        <h3 className="text-3xl font-bold text-white">48h</h3>
                      </div>
                    </div>
                    
                    <div className="mb-6 p-5 bg-[#0F172A]/40 border border-[#76EAD7]/10 rounded-xl">
                      <div className="flex items-center mb-3">
                        <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 text-[#76EAD7] mr-2" viewBox="0 0 20 20" fill="currentColor">
                          <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clipRule="evenodd" />
                        </svg>
                        <h4 className="text-white font-medium">Verification Instructions</h4>
                      </div>
                      <p className="text-[#94A3B8] text-sm">
                        Each verification will mint carbon credit tokens directly to the reporter's wallet address. The amount of tokens you specify will be minted 
                        as a reward for their sustainability efforts. Review the report details carefully before verification.
                      </p>
                    </div>
                    
                    {pendingReports.length === 0 ? (
                      <div className="text-center py-20 bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/10">
                        <svg xmlns="http://www.w3.org/2000/svg" className="h-16 w-16 text-[#76EAD7]/30 mx-auto mb-4" viewBox="0 0 20 20" fill="currentColor">
                          <path fillRule="evenodd" d="M6 2a2 2 0 00-2 2v12a2 2 0 002 2h8a2 2 0 002-2V7.414A2 2 0 0015.414 6L12 2.586A2 2 0 0010.586 2H6zm5 6a1 1 0 10-2 0v2H7a1 1 0 100 2h2v2a1 1 0 102 0v-2h2a1 1 0 100-2h-2V8z" />
                        </svg>
                        <h3 className="text-xl font-medium text-white mb-2">No Pending Reports</h3>
                        <p className="text-[#94A3B8]">There are no sustainability reports awaiting verification.</p>
                      </div>
                    ) : (
                      <div className="space-y-6">
                        {pendingReports.map((report, index) => (
                          <ReportVerificationCard
                            key={index}
                            report={report}
                            index={index}
                            onVerify={handleReportVerification}
                          />
                        ))}
                      </div>
                    )}
                  </div>
                )}
              </>
            )}
          </div>
        )}
      </div>
      
      {/* Toast Notification */}
      {toast && (
        <Toast 
          message={toast.message} 
          type={toast.type} 
          onClose={() => setToast(null)} 
        />
      )}
    </div>
  );
};

export default Admin; 