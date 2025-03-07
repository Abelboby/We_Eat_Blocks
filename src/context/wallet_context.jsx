import { createContext, useState, useContext, useEffect } from 'react';
import { connectWallet, checkCompanyExists, getCompanyDetails } from '../services/auth_service';

const WalletContext = createContext();

export const useWallet = () => useContext(WalletContext);

export const WalletProvider = ({ children }) => {
  const [walletAddress, setWalletAddress] = useState(null);
  const [isConnecting, setIsConnecting] = useState(false);
  const [connectionError, setConnectionError] = useState(null);
  
  const [company, setCompany] = useState(null);
  const [companyId, setCompanyId] = useState(null);
  const [isCompanyLoading, setIsCompanyLoading] = useState(false);
  
  // Connect wallet function
  const connect = async () => {
    try {
      setIsConnecting(true);
      setConnectionError(null);
      
      const result = await connectWallet();
      
      if (result.success) {
        setWalletAddress(result.address);
        
        // Check if wallet is associated with a company
        const companyCheck = await checkCompanyExists(result.address);
        
        if (companyCheck.exists) {
          setCompanyId(companyCheck.id);
          setCompany(companyCheck.data);
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
  const disconnect = () => {
    setWalletAddress(null);
    setCompany(null);
    setCompanyId(null);
  };
  
  // Load company details
  const loadCompanyDetails = async () => {
    if (!companyId) return;
    
    try {
      setIsCompanyLoading(true);
      const result = await getCompanyDetails(companyId);
      
      if (result.success) {
        setCompany(result.data);
      }
    } catch (error) {
      console.error("Error loading company details:", error);
    } finally {
      setIsCompanyLoading(false);
    }
  };
  
  // Update company data after registration or changes
  const updateCompanyData = (data) => {
    setCompany(data);
  };
  
  // Set company ID
  const setCompanyData = (id, data) => {
    setCompanyId(id);
    setCompany(data);
  };
  
  // Effect to load company details when companyId changes
  useEffect(() => {
    if (companyId) {
      loadCompanyDetails();
    }
  }, [companyId]);
  
  // Values to provide through context
  const value = {
    walletAddress,
    isConnecting,
    connectionError,
    company,
    companyId,
    isCompanyLoading,
    connect,
    disconnect,
    updateCompanyData,
    setCompanyData,
    loadCompanyDetails
  };
  
  return (
    <WalletContext.Provider value={value}>
      {children}
    </WalletContext.Provider>
  );
}; 