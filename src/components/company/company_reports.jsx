import { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { useWallet } from '../../context/wallet_context';
import { getPendingReports, getVerifiedReports } from '../../services/carbon_contract_service';

const CompanyReports = () => {
  const { walletAddress } = useWallet();
  
  const [pendingReports, setPendingReports] = useState([]);
  const [verifiedReports, setVerifiedReports] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);
  const [activeTab, setActiveTab] = useState('pending');
  const [selectedReport, setSelectedReport] = useState(null);
  
  // Load user reports
  useEffect(() => {
    if (walletAddress) {
      loadReports();
    }
  }, [walletAddress]);
  
  // Load reports from blockchain
  const loadReports = async () => {
    try {
      setIsLoading(true);
      setError(null);
      
      // Get pending reports
      const pendingResult = await getPendingReports();
      if (pendingResult.success) {
        // Filter reports submitted by current user (safely)
        const userPendingReports = Array.isArray(pendingResult.reports) 
          ? pendingResult.reports.filter(
              report => report && report.reporter && walletAddress && 
              report.reporter.toLowerCase() === walletAddress.toLowerCase()
            )
          : [];
        setPendingReports(userPendingReports);
      } else if (pendingResult.error) {
        console.warn('Warning getting pending reports:', pendingResult.error);
      }
      
      // Get verified reports - now passing wallet address to filter server-side
      const verifiedResult = await getVerifiedReports(walletAddress);
      if (verifiedResult.success) {
        // The filtering is now done in the service function
        setVerifiedReports(verifiedResult.reports);
      } else if (verifiedResult.error) {
        console.warn('Warning getting verified reports:', verifiedResult.error);
      }
    } catch (error) {
      console.error('Error loading reports:', error);
      setError('Failed to load reports. Please make sure you are connected to the Sepolia testnet.');
    } finally {
      setIsLoading(false);
    }
  };
  
  // Format timestamp to readable date
  const formatTimestamp = (timestamp) => {
    if (!timestamp) return 'N/A';
    
    try {
      const date = new Date(Number(timestamp) * 1000);
      if (isNaN(date.getTime())) return 'Invalid Date';
      
      return new Intl.DateTimeFormat('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      }).format(date);
    } catch (error) {
      console.error('Error formatting timestamp:', error);
      return 'Error';
    }
  };
  
  // Format coordinate value
  const formatCoordinate = (coord, direction) => {
    if (!coord) return 'N/A';
    
    try {
      // Convert from int to decimal
      const coordStr = coord.toString();
      const decimal = coordStr.length > 2 
        ? `${coordStr.slice(0, -2)}.${coordStr.slice(-2)}` 
        : `0.${coordStr}`;
        
      return `${decimal}° ${direction}`;
    } catch (error) {
      console.error('Error formatting coordinate:', error);
      return 'Error';
    }
  };
  
  // Select report for detailed view
  const handleSelectReport = (report) => {
    setSelectedReport(report);
  };
  
  // Clear selected report
  const clearSelectedReport = () => {
    setSelectedReport(null);
  };

  // Render verified reports list
  const renderVerifiedReportsList = () => {
    return verifiedReports.length > 0 ? (
      <div className="space-y-4">
        {verifiedReports.map((report, index) => (
          <motion.div 
            key={index}
            whileHover={{ scale: 1.01 }}
            className="bg-[#0F172A]/40 rounded-xl border border-[#76EAD7]/10 p-4 cursor-pointer hover:border-[#76EAD7]/30 transition-all"
            onClick={() => handleSelectReport(report)}
          >
            <div className="flex items-start">
              <div className="bg-green-500/10 p-2 rounded-lg mr-4">
                <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6 text-green-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <div className="flex-1">
                <h3 className="text-white font-medium">{report.title}</h3>
                <div className="flex items-center mt-1">
                  <span className="text-[#94A3B8] text-sm mr-3">
                    {formatTimestamp(report.timestamp)}
                  </span>
                  <span className="bg-[#76EAD7]/10 rounded-lg px-2 py-0.5 text-xs text-[#76EAD7]">
                    {report.category}
                  </span>
                </div>
              </div>
              <div className="flex-shrink-0">
                <div className="bg-green-500/10 px-2 py-1 rounded-full flex items-center mb-1">
                  <div className="w-2 h-2 rounded-full bg-green-400 mr-1"></div>
                  <span className="text-green-400 text-xs">Verified</span>
                </div>
                <div className="text-right">
                  <span className="text-white font-medium text-sm">
                    +{report.mintedTokens || 0} Tonnes
                  </span>
                </div>
              </div>
            </div>
          </motion.div>
        ))}
      </div>
    ) : (
      <div className="text-center py-20 bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/10">
        <svg xmlns="http://www.w3.org/2000/svg" className="h-16 w-16 text-[#76EAD7]/30 mx-auto mb-4" viewBox="0 0 20 20" fill="currentColor">
          <path fillRule="evenodd" d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
        </svg>
        <h3 className="text-lg font-medium text-white mb-2">No Verified Reports</h3>
        <p className="text-[#94A3B8] max-w-md mx-auto">
          You don't have any verified reports yet. Once your submitted reports are verified, they'll appear here.
        </p>
      </div>
    );
  };

  // Display error or loading state
  if (isLoading && !selectedReport) {
    return (
      <div className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10">
        <div className="flex justify-center items-center p-8">
          <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-[#76EAD7]"></div>
        </div>
        <p className="text-center text-white mt-4">Loading your reports...</p>
      </div>
    );
  }
  
  if (error) {
    return (
      <div className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10">
        <div className="text-center py-8">
          <svg xmlns="http://www.w3.org/2000/svg" className="h-16 w-16 text-red-400 mx-auto mb-4" viewBox="0 0 20 20" fill="currentColor">
            <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
          </svg>
          <h3 className="text-lg font-medium text-white mb-2">Error Loading Reports</h3>
          <p className="text-[#94A3B8] max-w-md mx-auto">{error}</p>
          <button 
            onClick={loadReports}
            className="mt-4 px-4 py-2 bg-[#76EAD7]/10 border border-[#76EAD7]/30 rounded-lg text-[#76EAD7] hover:bg-[#76EAD7]/20"
          >
            Try Again
          </button>
        </div>
      </div>
    );
  }

  return (
    <div>
      {selectedReport ? (
        // Report Detail View
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/10 overflow-hidden"
        >
          {/* Header with back button */}
          <div className="p-6 border-b border-[#76EAD7]/20 flex justify-between items-center">
            <h3 className="text-lg font-semibold text-white flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 mr-2 text-[#76EAD7]" viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M4 4a2 2 0 012-2h8a2 2 0 012 2v12a1 1 0 01-1 1h-2a1 1 0 01-1-1v-2a1 1 0 00-1-1H7a1 1 0 00-1 1v2a1 1 0 01-1 1H3a1 1 0 01-1-1V4zm3 1h2v2H7V5zm2 4H7v2h2V9zm2-4h2v2h-2V5zm2 4h-2v2h2V9z" clipRule="evenodd" />
              </svg>
              Report Details
            </h3>
            
            <button 
              onClick={clearSelectedReport}
              className="text-[#94A3B8] hover:text-white transition-colors"
            >
              <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
              </svg>
            </button>
          </div>
          
          {/* Report Content */}
          <div className="p-6">
            {/* Report Status */}
            <div className="flex items-center mb-6">
              <div className={`px-3 py-1 rounded-full mr-3 flex items-center ${
                selectedReport.verified 
                  ? 'bg-green-500/10 text-green-400'
                  : 'bg-orange-500/10 text-orange-400'
              }`}>
                <div className={`w-2 h-2 rounded-full mr-2 ${
                  selectedReport.verified ? 'bg-green-400' : 'bg-orange-400'
                }`}></div>
                <span>{selectedReport.verified ? 'Verified' : 'Pending'}</span>
              </div>
              
              <span className="text-[#94A3B8] text-sm">
                Submitted {formatTimestamp(selectedReport.timestamp)}
              </span>
            </div>
            
            {/* Title and Category */}
            <div className="mb-6">
              <h2 className="text-xl font-bold text-white mb-2">
                {selectedReport.title}
              </h2>
              <div className="inline-block bg-[#76EAD7]/10 rounded-lg px-3 py-1">
                <span className="text-[#76EAD7] text-sm">{selectedReport.category}</span>
              </div>
            </div>
            
            {/* Verification Results (if verified) */}
            {selectedReport.verified && (
              <div className="mb-6 p-4 bg-[#0F172A]/60 rounded-xl border border-[#76EAD7]/10">
                <h4 className="text-white font-medium mb-2 flex items-center">
                  <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 mr-2 text-green-400" viewBox="0 0 20 20" fill="currentColor">
                    <path fillRule="evenodd" d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                  </svg>
                  Verification Results
                </h4>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 mt-3">
                  <div>
                    <p className="text-[#94A3B8] text-sm">Carbon Credits Issued</p>
                    <p className="text-white font-medium text-lg">{selectedReport.mintedTokens || 0} Tonnes</p>
                  </div>
                  <div>
                    <p className="text-[#94A3B8] text-sm">Verification Date</p>
                    <p className="text-white">{formatTimestamp(selectedReport.timestamp)}</p>
                  </div>
                </div>
              </div>
            )}
            
            {/* Description */}
            <div className="mb-6">
              <h4 className="text-white font-medium mb-2">Description</h4>
              <div className="p-4 bg-[#0F172A]/60 rounded-xl border border-[#76EAD7]/10">
                <p className="text-[#94A3B8] whitespace-pre-line">{selectedReport.description}</p>
              </div>
            </div>
            
            {/* Location Information */}
            {(selectedReport.latitude || selectedReport.longitude) && (
              <div className="mb-6">
                <h4 className="text-white font-medium mb-2">Location</h4>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div className="p-4 bg-[#0F172A]/60 rounded-xl border border-[#76EAD7]/10">
                    <p className="text-[#94A3B8] text-sm">Latitude</p>
                    <p className="text-white font-medium">
                      {formatCoordinate(selectedReport.latitude, selectedReport.latDirection)}
                    </p>
                  </div>
                  <div className="p-4 bg-[#0F172A]/60 rounded-xl border border-[#76EAD7]/10">
                    <p className="text-[#94A3B8] text-sm">Longitude</p>
                    <p className="text-white font-medium">
                      {formatCoordinate(selectedReport.longitude, selectedReport.longDirection)}
                    </p>
                  </div>
                </div>
              </div>
            )}
            
            {/* Evidence Link */}
            {selectedReport.evidence && (
              <div className="mb-6">
                <h4 className="text-white font-medium mb-2">Evidence</h4>
                <div className="p-4 bg-[#0F172A]/60 rounded-xl border border-[#76EAD7]/10">
                  <a 
                    href={selectedReport.evidence}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-[#76EAD7] hover:underline break-all"
                  >
                    {selectedReport.evidence}
                  </a>
                </div>
              </div>
            )}
          </div>
        </motion.div>
      ) : (
        // Reports List View
        <div className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/10 overflow-hidden p-6">
          {/* Tab Buttons */}
          <div className="flex justify-between items-center mb-6">
            <div className="border-b border-[#76EAD7]/10 flex-grow">
              <nav className="flex">
                <button
                  className={`py-3 px-4 border-b-2 font-medium ${
                    activeTab === 'pending'
                      ? 'border-[#76EAD7] text-[#76EAD7]'
                      : 'border-transparent text-[#94A3B8] hover:text-white'
                  }`}
                  onClick={() => setActiveTab('pending')}
                >
                  Pending Reports
                  {pendingReports.length > 0 && (
                    <span className="ml-2 bg-yellow-500/10 text-yellow-400 rounded-full px-2 py-0.5 text-xs">
                      {pendingReports.length}
                    </span>
                  )}
                </button>
                <button
                  className={`py-3 px-4 border-b-2 font-medium ${
                    activeTab === 'verified'
                      ? 'border-[#76EAD7] text-[#76EAD7]'
                      : 'border-transparent text-[#94A3B8] hover:text-white'
                  }`}
                  onClick={() => setActiveTab('verified')}
                >
                  Verified Reports
                  {verifiedReports.length > 0 && (
                    <span className="ml-2 bg-green-500/10 text-green-400 rounded-full px-2 py-0.5 text-xs">
                      {verifiedReports.length}
                    </span>
                  )}
                </button>
              </nav>
            </div>
            <motion.button
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              onClick={loadReports}
              disabled={isLoading}
              className="ml-4 p-2 rounded-full bg-[#0F172A]/80 border border-[#76EAD7]/20 hover:bg-[#76EAD7]/10 transition-colors"
              title="Refresh Reports"
            >
              <svg 
                xmlns="http://www.w3.org/2000/svg" 
                className={`h-5 w-5 text-[#76EAD7] ${isLoading ? 'animate-spin' : ''}`} 
                fill="none" 
                viewBox="0 0 24 24" 
                stroke="currentColor"
              >
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
              </svg>
            </motion.button>
          </div>
          
          {/* Loading State */}
          {isLoading && (
            <div className="flex items-center justify-center py-20">
              <div className="w-12 h-12 border-4 border-[#76EAD7]/30 border-t-[#76EAD7] rounded-full animate-spin"></div>
            </div>
          )}
          
          {/* Content based on active tab */}
          {!isLoading && (
            <>
              {activeTab === 'pending' ? (
                // Pending Reports
                pendingReports.length > 0 ? (
                  <div className="space-y-4">
                    {pendingReports.map((report, index) => (
                      <motion.div 
                        key={index}
                        whileHover={{ scale: 1.01 }}
                        className="bg-[#0F172A]/40 rounded-xl border border-[#76EAD7]/10 p-4 cursor-pointer hover:border-[#76EAD7]/30 transition-all"
                        onClick={() => handleSelectReport(report)}
                      >
                        <div className="flex items-start">
                          <div className="bg-orange-500/10 p-2 rounded-lg mr-4">
                            <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6 text-orange-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                          </div>
                          <div className="flex-1">
                            <h3 className="text-white font-medium">{report.title}</h3>
                            <div className="flex items-center mt-1">
                              <span className="text-[#94A3B8] text-sm mr-3">
                                {formatTimestamp(report.timestamp)}
                              </span>
                              <span className="bg-[#76EAD7]/10 rounded-lg px-2 py-0.5 text-xs text-[#76EAD7]">
                                {report.category}
                              </span>
                            </div>
                          </div>
                          <div className="flex-shrink-0 bg-orange-500/10 px-2 py-1 rounded-full flex items-center">
                            <div className="w-2 h-2 rounded-full bg-orange-400 mr-1"></div>
                            <span className="text-orange-400 text-xs">Pending</span>
                          </div>
                        </div>
                      </motion.div>
                    ))}
                  </div>
                ) : (
                  <div className="text-center py-20 bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/10">
                    <svg xmlns="http://www.w3.org/2000/svg" className="h-16 w-16 text-[#76EAD7]/20 mx-auto mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                    </svg>
                    <h3 className="text-lg font-medium text-white mb-2">No Pending Reports</h3>
                    <p className="text-[#94A3B8] max-w-md mx-auto">
                      You don't have any pending reports. Click the "Submit Report" button to create a new sustainability report.
                    </p>
                  </div>
                )
              ) : (
                // Verified Reports
                renderVerifiedReportsList()
              )}
            </>
          )}
        </div>
      )}
    </div>
  );
};

export default CompanyReports; 