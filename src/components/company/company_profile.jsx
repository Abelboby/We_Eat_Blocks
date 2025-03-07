import { motion } from 'framer-motion';
import { useState, useEffect } from 'react';
import { useWallet } from '../../context/wallet_context';
import { getTokenBalance } from '../../services/carbon_contract_service';
import CompanyReports from './company_reports';

const CompanyProfile = () => {
  const { company, walletAddress } = useWallet();
  const [activeTab, setActiveTab] = useState('overview');
  const [tokenBalance, setTokenBalance] = useState('0');
  const [isLoadingBalance, setIsLoadingBalance] = useState(false);
  
  // Load token balance from smart contract
  useEffect(() => {
    const loadTokenBalance = async () => {
      if (!walletAddress) return;
      
      try {
        setIsLoadingBalance(true);
        const result = await getTokenBalance(walletAddress);
        
        if (result.success) {
          // Convert from wei to eth (tokens)
          const balance = parseFloat(result.balance) / 1e18;
          setTokenBalance(balance.toFixed(2));
        }
      } catch (error) {
        console.error("Error loading token balance:", error);
      } finally {
        setIsLoadingBalance(false);
      }
    };
    
    loadTokenBalance();
  }, [walletAddress]);
  
  // Manual refresh function for token balance
  const refreshTokenBalance = async () => {
    if (!walletAddress) return;
    
    try {
      setIsLoadingBalance(true);
      const result = await getTokenBalance(walletAddress);
      
      if (result.success) {
        // Convert from wei to eth (tokens)
        const balance = parseFloat(result.balance) / 1e18;
        setTokenBalance(balance.toFixed(2));
      }
    } catch (error) {
      console.error("Error refreshing token balance:", error);
    } finally {
      setIsLoadingBalance(false);
    }
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
  
  // Format wallet address
  const formatAddress = (address) => {
    if (!address) return '0x...';
    return `${address.substring(0, 6)}...${address.substring(address.length - 4)}`;
  };
  
  if (!company) {
    return (
      <div className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10">
        <div className="text-center py-10">
          <div className="w-16 h-16 bg-[#76EAD7]/10 rounded-full flex items-center justify-center mx-auto mb-4">
            <svg xmlns="http://www.w3.org/2000/svg" className="h-8 w-8 text-[#76EAD7]" viewBox="0 0 20 20" fill="currentColor">
              <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-3a1 1 0 00-.867.5 1 1 0 11-1.731-1A3 3 0 0113 8a3.001 3.001 0 01-2 2.83V11a1 1 0 11-2 0v-1a1 1 0 011-1 1 1 0 100-2zm0 8a1 1 0 100-2 1 1 0 000 2z" clipRule="evenodd" />
            </svg>
          </div>
          <h3 className="text-lg font-medium text-white mb-2">No Company Profile</h3>
          <p className="text-[#94A3B8]">Company information not found</p>
        </div>
      </div>
    );
  }
  
  return (
    <div className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl overflow-hidden border border-[#76EAD7]/10">
      {/* Navigation Tabs */}
      <div className="flex border-b border-[#76EAD7]/20">
        <button 
          className={`py-4 px-6 text-center font-medium ${
            activeTab === 'overview'
              ? 'text-[#76EAD7] border-b-2 border-[#76EAD7]'
              : 'text-[#94A3B8] hover:text-white'
          }`}
          onClick={() => setActiveTab('overview')}
        >
          Overview
        </button>
        <button 
          className={`py-4 px-6 text-center font-medium ${
            activeTab === 'transactions'
              ? 'text-[#76EAD7] border-b-2 border-[#76EAD7]'
              : 'text-[#94A3B8] hover:text-white'
          }`}
          onClick={() => setActiveTab('transactions')}
        >
          Transactions
        </button>
        <button 
          className={`py-4 px-6 text-center font-medium ${
            activeTab === 'reports'
              ? 'text-[#76EAD7] border-b-2 border-[#76EAD7]'
              : 'text-[#94A3B8] hover:text-white'
          }`}
          onClick={() => setActiveTab('reports')}
        >
          Reports
        </button>
      </div>
      
      {/* Content based on active tab */}
      {activeTab === 'overview' && (
        <div className="p-6">
          {/* Company Info Section */}
          <div className="flex flex-col md:flex-row md:items-start mb-8">
            <div className="flex-shrink-0 mb-4 md:mb-0 md:mr-6">
              <div className="w-20 h-20 bg-[#76EAD7]/10 rounded-full flex items-center justify-center">
                <svg xmlns="http://www.w3.org/2000/svg" className="h-10 w-10 text-[#76EAD7]" viewBox="0 0 20 20" fill="currentColor">
                  <path fillRule="evenodd" d="M4 4a2 2 0 012-2h8a2 2 0 012 2v12a1 1 0 01-1 1h-2a1 1 0 01-1-1v-2a1 1 0 00-1-1H7a1 1 0 00-1 1v2a1 1 0 01-1 1H3a1 1 0 01-1-1V4zm3 1h2v2H7V5zm2 4H7v2h2V9zm2-4h2v2h-2V5zm2 4h-2v2h2V9z" clipRule="evenodd" />
                </svg>
              </div>
            </div>
            
            <div className="flex-1">
              <h3 className="text-xl font-bold text-white mb-1">{company.name}</h3>
              <p className="text-[#94A3B8] mb-3">{company.industry}</p>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                <div>
                  <p className="text-[#94A3B8] text-sm">Registration Date</p>
                  <p className="text-white">{formatDate(company.registrationDate)}</p>
                </div>
                <div>
                  <p className="text-[#94A3B8] text-sm">Wallet Address</p>
                  <p className="text-white font-mono">{formatAddress(company.walletAddress)}</p>
                </div>
              </div>
              
              {company.website && (
                <div className="mb-4">
                  <p className="text-[#94A3B8] text-sm">Website</p>
                  <a 
                    href={company.website}
                    target="_blank" 
                    rel="noopener noreferrer"
                    className="text-[#76EAD7] hover:underline"
                  >
                    {company.website}
                  </a>
                </div>
              )}
              
              {company.description && (
                <div>
                  <p className="text-[#94A3B8] text-sm mb-1">About</p>
                  <p className="text-white">{company.description}</p>
                </div>
              )}
            </div>
          </div>
          
          {/* Token Balances */}
          <h4 className="text-lg font-medium text-white mb-4">Carbon Credit Balances</h4>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
            <motion.div 
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5 }}
              className="bg-[#0F172A]/40 p-5 rounded-xl border border-[#76EAD7]/20 feature-card-enhanced"
            >
              <div className="flex justify-between items-center mb-3">
                <span className="text-[#76EAD7] px-3 py-1 bg-[#76EAD7]/10 rounded-lg font-medium">Carbon Credits</span>
                <div className="flex items-center">
                  <button 
                    onClick={refreshTokenBalance}
                    disabled={isLoadingBalance}
                    className="p-2 rounded-full bg-[#0F172A] mr-3 hover:bg-[#76EAD7]/10 transition-colors"
                    title="Refresh balance"
                  >
                    <svg xmlns="http://www.w3.org/2000/svg" className={`h-4 w-4 text-[#76EAD7] ${isLoadingBalance ? 'animate-spin' : ''}`} fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                    </svg>
                  </button>
                  <div className="feature-icon-enhanced w-10 h-10 bg-[#0F172A] rounded-full flex items-center justify-center flex-shrink-0">
                    <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 text-[#76EAD7] icon-glow" viewBox="0 0 20 20" fill="currentColor">
                      <path d="M4 4a2 2 0 00-2 2v1h16V6a2 2 0 00-2-2H4z" />
                      <path fillRule="evenodd" d="M18 9H2v5a2 2 0 002 2h12a2 2 0 002-2V9zM4 13a1 1 0 011-1h1a1 1 0 110 2H5a1 1 0 01-1-1zm5-1a1 1 0 100 2h1a1 1 0 100-2H9z" clipRule="evenodd" />
                    </svg>
                  </div>
                </div>
              </div>
              <div className="mt-2">
                {isLoadingBalance ? (
                  <div className="flex items-center space-x-2">
                    <div className="h-5 w-5 border-2 border-[#76EAD7]/30 border-t-[#76EAD7] rounded-full animate-spin"></div>
                    <p className="text-[#94A3B8] text-sm">Loading balance...</p>
                  </div>
                ) : (
                  <>
                    <p className="text-white font-bold text-3xl mb-1 gradient-text">{tokenBalance}</p>
                    <div className="flex items-center justify-between">
                      <p className="text-[#94A3B8] text-sm">Carbon Credit Tokens</p>
                      <span className="text-xs px-2 py-1 bg-green-500/10 text-green-400 rounded-full flex items-center">
                        <span className="w-1.5 h-1.5 bg-green-400 rounded-full mr-1"></span>
                        Live Balance
                      </span>
                    </div>
                  </>
                )}
              </div>
            </motion.div>
            
            {company.tokenBalances && Object.entries(company.tokenBalances).map(([token, amount]) => (
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
            ))}
            
            {!company.tokenBalances && tokenBalance === '0' && (
              <div className="col-span-3 text-center text-[#94A3B8] p-6">
                No token balances available
              </div>
            )}
          </div>
          
          {/* NFT Certificates Section */}
          <h4 className="text-lg font-medium text-white mb-4">Retirement Certificates</h4>
          <div className="bg-[#0F172A]/40 rounded-xl border border-[#76EAD7]/10 p-6">
            <div className="text-center">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-16 w-16 text-[#76EAD7]/20 mx-auto mb-4" viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M5 2a1 1 0 011 1v1h1a1 1 0 010 2H6v1a1 1 0 01-2 0V6H3a1 1 0 010-2h1V3a1 1 0 011-1zm0 10a1 1 0 011 1v1h1a1 1 0 110 2H6v1a1 1 0 11-2 0v-1H3a1 1 0 110-2h1v-1a1 1 0 011-1zM12 2a1 1 0 01.967.744L14.146 7.2 17.5 9.134a1 1 0 010 1.732l-3.354 1.935-1.18 4.455a1 1 0 01-1.933 0L9.854 12.8 6.5 10.866a1 1 0 010-1.732l3.354-1.935 1.18-4.455A1 1 0 0112 2z" clipRule="evenodd" />
              </svg>
              <h3 className="text-lg font-medium text-white mb-2">No Certificates Yet</h3>
              <p className="text-[#94A3B8] max-w-md mx-auto">
                When you retire carbon credits, you'll receive NFT certificates that will appear here.
              </p>
              <button className="mt-4 px-4 py-2 rounded-lg bg-[#76EAD7]/10 border border-[#76EAD7]/30 text-[#76EAD7] hover:bg-[#76EAD7]/20 transition-colors">
                Retire Credits
              </button>
            </div>
          </div>
        </div>
      )}
      
      {activeTab === 'transactions' && (
        <div className="p-6">
          <h4 className="text-lg font-medium text-white mb-4">Recent Transactions</h4>
          {sampleTransactions.length > 0 ? (
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
                        Status
                      </th>
                      <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-[#94A3B8] uppercase tracking-wider">
                        Hash
                      </th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-[#76EAD7]/10">
                    {sampleTransactions.map((tx) => (
                      <tr key={tx.id} className="hover:bg-[#0F172A]/20">
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
                          <span className="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                            {tx.status}
                          </span>
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
            <div className="text-center py-10 bg-[#0F172A]/40 rounded-xl border border-[#76EAD7]/10">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-16 w-16 text-[#76EAD7]/20 mx-auto mb-4" viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clipRule="evenodd" />
              </svg>
              <h3 className="text-lg font-medium text-white mb-2">No Transactions</h3>
              <p className="text-[#94A3B8]">You haven't made any transactions yet.</p>
            </div>
          )}
        </div>
      )}
      
      {/* Reports Tab */}
      {activeTab === 'reports' && (
        <div className="p-6">
          <CompanyReports />
        </div>
      )}
    </div>
  );
};

export default CompanyProfile; 