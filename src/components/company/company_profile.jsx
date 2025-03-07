import { motion } from 'framer-motion';
import { useState } from 'react';
import { useWallet } from '../../context/wallet_context';

const CompanyProfile = () => {
  const { company, walletAddress } = useWallet();
  const [activeTab, setActiveTab] = useState('overview');
  
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
  
  // Sample transaction data (would come from Firebase in real app)
  const sampleTransactions = [
    {
      id: 'tx-001',
      type: 'Purchase',
      amount: 100,
      token: 'NCT',
      date: new Date(Date.now() - 86400000 * 2), // 2 days ago
      status: 'Completed',
      hash: '0x' + Math.random().toString(16).slice(2, 42),
    },
    {
      id: 'tx-002',
      type: 'Sale',
      amount: 50,
      token: 'BCT',
      date: new Date(Date.now() - 86400000 * 5), // 5 days ago
      status: 'Completed',
      hash: '0x' + Math.random().toString(16).slice(2, 42),
    },
    {
      id: 'tx-003',
      type: 'Retirement',
      amount: 25,
      token: 'NCT',
      date: new Date(Date.now() - 86400000 * 10), // 10 days ago
      status: 'Completed',
      hash: '0x' + Math.random().toString(16).slice(2, 42),
    },
  ];
  
  // Sample token balances (would come from Firebase in real app)
  const tokenBalances = [
    { token: 'NCT', name: 'Nature Carbon Tonne', amount: 250, value: 24625 },
    { token: 'BCT', name: 'Base Carbon Tonne', amount: 100, value: 12530 },
    { token: 'CHAR', name: 'Toucan Biochar Carbon', amount: 50, value: 7360 },
  ];
  
  return (
    <div className="space-y-6">
      {/* Company Overview Card */}
      <motion.div
        className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
      >
        <div className="md:flex justify-between items-start">
          <div>
            <h2 className="text-2xl font-bold text-white">{company?.name || 'Company Name'}</h2>
            <p className="text-[#94A3B8] mt-1">{company?.industry || 'Industry'}</p>
          </div>
          
          <div className="mt-4 md:mt-0 bg-[#0F172A]/80 px-4 py-2 rounded-xl border border-[#76EAD7]/10 flex flex-col sm:flex-row items-center gap-3">
            <span className="text-[#94A3B8]">MetaMask:</span>
            <div className="flex items-center space-x-2">
              <img src="/src/assets/metamask.png" alt="MetaMask" className="w-4 h-4" />
              <span className="text-white text-sm font-mono truncate max-w-[120px] sm:max-w-[200px]">
                {walletAddress || '0x...'}
              </span>
              <div className="w-2 h-2 rounded-full bg-green-400"></div>
            </div>
          </div>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mt-6">
          <div className="p-4 bg-[#0F172A]/60 rounded-xl border border-[#76EAD7]/10">
            <p className="text-[#94A3B8] text-sm">Registered</p>
            <p className="text-white font-medium mt-1">{formatDate(company?.registrationDate) || 'N/A'}</p>
          </div>
          
          <div className="p-4 bg-[#0F172A]/60 rounded-xl border border-[#76EAD7]/10">
            <p className="text-[#94A3B8] text-sm">Status</p>
            <div className="flex items-center mt-1">
              <div className={`w-2 h-2 rounded-full ${
                company?.verificationStatus === 'approved' ? 'bg-green-400' : 
                company?.verificationStatus === 'rejected' ? 'bg-red-400' : 'bg-yellow-400'
              } mr-2`}></div>
              <p className="text-white font-medium">
                {company?.verificationStatus === 'approved' ? 'Verified' : 
                 company?.verificationStatus === 'rejected' ? 'Rejected' : 'Pending Verification'}
              </p>
            </div>
            {company?.verificationStatus === 'rejected' && company?.rejectionReason && (
              <p className="text-red-400 text-xs mt-2">
                Reason: {company.rejectionReason}
              </p>
            )}
          </div>
          
          <div className="p-4 bg-[#0F172A]/60 rounded-xl border border-[#76EAD7]/10">
            <p className="text-[#94A3B8] text-sm">Contact</p>
            <p className="text-white font-medium mt-1 truncate">{company?.email || 'N/A'}</p>
          </div>
        </div>
      </motion.div>
      
      {/* Tab Navigation */}
      <div className="border-b border-[#76EAD7]/10">
        <nav className="flex space-x-8">
          <button
            onClick={() => setActiveTab('overview')}
            className={`py-3 px-1 border-b-2 font-medium text-sm ${
              activeTab === 'overview'
                ? 'border-[#76EAD7] text-[#76EAD7]'
                : 'border-transparent text-[#94A3B8] hover:text-white'
            }`}
          >
            Overview
          </button>
          <button
            onClick={() => setActiveTab('balances')}
            className={`py-3 px-1 border-b-2 font-medium text-sm ${
              activeTab === 'balances'
                ? 'border-[#76EAD7] text-[#76EAD7]'
                : 'border-transparent text-[#94A3B8] hover:text-white'
            }`}
          >
            Token Balances
          </button>
          <button
            onClick={() => setActiveTab('transactions')}
            className={`py-3 px-1 border-b-2 font-medium text-sm ${
              activeTab === 'transactions'
                ? 'border-[#76EAD7] text-[#76EAD7]'
                : 'border-transparent text-[#94A3B8] hover:text-white'
            }`}
          >
            Transactions
          </button>
        </nav>
      </div>
      
      {/* Tab Content */}
      <div className="mt-6">
        {/* Overview Tab */}
        {activeTab === 'overview' && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.3 }}
            className="space-y-6"
          >
            <div className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10">
              <h3 className="text-lg font-medium text-white mb-4">Company Details</h3>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <h4 className="text-[#94A3B8] text-sm">Company Name</h4>
                  <p className="text-white mt-1">{company?.name || 'N/A'}</p>
                </div>
                
                <div>
                  <h4 className="text-[#94A3B8] text-sm">Industry</h4>
                  <p className="text-white mt-1">{company?.industry || 'N/A'}</p>
                </div>
                
                <div>
                  <h4 className="text-[#94A3B8] text-sm">Email</h4>
                  <p className="text-white mt-1">{company?.email || 'N/A'}</p>
                </div>
                
                <div>
                  <h4 className="text-[#94A3B8] text-sm">Website</h4>
                  <p className="text-white mt-1">
                    {company?.website ? (
                      <a href={company.website} target="_blank" rel="noopener noreferrer" className="text-[#76EAD7] hover:underline">
                        {company.website}
                      </a>
                    ) : (
                      'N/A'
                    )}
                  </p>
                </div>
                
                <div className="col-span-1 md:col-span-2">
                  <h4 className="text-[#94A3B8] text-sm">Description</h4>
                  <p className="text-white mt-1">{company?.description || 'No description available.'}</p>
                </div>
              </div>
            </div>
            
            <div className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10">
              <h3 className="text-lg font-medium text-white mb-4">Contact Information</h3>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <h4 className="text-[#94A3B8] text-sm">Contact Person</h4>
                  <p className="text-white mt-1">{company?.contactPerson || 'N/A'}</p>
                </div>
                
                <div>
                  <h4 className="text-[#94A3B8] text-sm">Contact Phone</h4>
                  <p className="text-white mt-1">{company?.contactPhone || 'N/A'}</p>
                </div>
              </div>
            </div>
          </motion.div>
        )}
        
        {/* Token Balances Tab */}
        {activeTab === 'balances' && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.3 }}
          >
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              {tokenBalances.map(balance => (
                <div 
                  key={balance.token}
                  className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10 hover:border-[#76EAD7]/30 transition-all"
                >
                  <div className="flex items-center justify-between mb-4">
                    <div className="bg-[#0F172A]/60 px-3 py-1 rounded-lg">
                      <span className="text-[#76EAD7] font-semibold">{balance.token}</span>
                    </div>
                    <div className="w-10 h-10 bg-[#76EAD7]/10 rounded-full flex items-center justify-center">
                      <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 text-[#76EAD7]" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M4 4a2 2 0 00-2 2v1h16V6a2 2 0 00-2-2H4z" />
                        <path fillRule="evenodd" d="M18 9H2v5a2 2 0 002 2h12a2 2 0 002-2V9zM4 13a1 1 0 011-1h1a1 1 0 110 2H5a1 1 0 01-1-1zm5-1a1 1 0 100 2h1a1 1 0 100-2H9z" clipRule="evenodd" />
                      </svg>
                    </div>
                  </div>
                  
                  <div>
                    <h3 className="text-lg font-medium text-white">{balance.name}</h3>
                    <div className="mt-4 space-y-2">
                      <div className="flex justify-between">
                        <span className="text-[#94A3B8]">Balance:</span>
                        <span className="text-white font-medium">{balance.amount} Tonnes</span>
                      </div>
                      <div className="flex justify-between">
                        <span className="text-[#94A3B8]">Value:</span>
                        <span className="text-white font-medium">${balance.value.toLocaleString()}</span>
                      </div>
                    </div>
                    
                    <div className="mt-6">
                      <button className="w-full py-2 bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] text-[#0F172A] font-semibold rounded-lg hover:shadow-lg transition-all">
                        Trade
                      </button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </motion.div>
        )}
        
        {/* Transactions Tab */}
        {activeTab === 'transactions' && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.3 }}
          >
            <div className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl overflow-hidden border border-[#76EAD7]/10">
              <div className="overflow-x-auto">
                <table className="min-w-full divide-y divide-[#76EAD7]/10">
                  <thead className="bg-[#0F172A]/40">
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
                        Status
                      </th>
                      <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-[#94A3B8] uppercase tracking-wider">
                        Tx Hash
                      </th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-[#76EAD7]/10">
                    {sampleTransactions.map((tx) => (
                      <tr key={tx.id} className="hover:bg-[#0F172A]/20">
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="flex items-center">
                            <div className={`
                              w-8 h-8 rounded-full flex items-center justify-center mr-3
                              ${tx.type === 'Purchase' ? 'bg-green-500/10' : ''}
                              ${tx.type === 'Sale' ? 'bg-blue-500/10' : ''}
                              ${tx.type === 'Retirement' ? 'bg-purple-500/10' : ''}
                            `}>
                              {tx.type === 'Purchase' && (
                                <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4 text-green-500" viewBox="0 0 20 20" fill="currentColor">
                                  <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-11a1 1 0 10-2 0v3.586L7.707 9.293a1 1 0 00-1.414 1.414l3 3a1 1 0 001.414 0l3-3a1 1 0 00-1.414-1.414L11 10.586V7z" clipRule="evenodd" />
                                </svg>
                              )}
                              {tx.type === 'Sale' && (
                                <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4 text-blue-500" viewBox="0 0 20 20" fill="currentColor">
                                  <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-11a1 1 0 10-2 0v3.586L7.707 9.293a1 1 0 00-1.414 1.414l3 3a1 1 0 001.414 0l3-3a1 1 0 00-1.414-1.414L11 10.586V7z" clipRule="evenodd" />
                                </svg>
                              )}
                              {tx.type === 'Retirement' && (
                                <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4 text-purple-500" viewBox="0 0 20 20" fill="currentColor">
                                  <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
                                </svg>
                              )}
                            </div>
                            <div>
                              <div className="text-sm font-medium text-white">{tx.type}</div>
                              <div className="text-xs text-[#94A3B8]">{tx.token}</div>
                            </div>
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="text-sm text-white">{tx.amount} Tonnes</div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="text-sm text-white">{formatDate(tx.date)}</div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <span className={`px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full
                            ${tx.status === 'Completed' ? 'bg-green-100 text-green-800' : ''}
                            ${tx.status === 'Pending' ? 'bg-yellow-100 text-yellow-800' : ''}
                            ${tx.status === 'Failed' ? 'bg-red-100 text-red-800' : ''}
                          `}>
                            {tx.status}
                          </span>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm">
                          <a href={`https://etherscan.io/tx/${tx.hash}`} target="_blank" rel="noopener noreferrer" className="text-[#76EAD7] hover:underline font-mono truncate block max-w-[120px]">
                            {tx.hash.substring(0, 8)}...{tx.hash.substring(tx.hash.length - 6)}
                          </a>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </motion.div>
        )}
      </div>
    </div>
  );
};

export default CompanyProfile; 