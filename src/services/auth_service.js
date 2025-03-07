import { auth, db } from './firebase_service';
import { 
  signInWithEmailAndPassword, 
  createUserWithEmailAndPassword,
  sendEmailVerification,
  signOut as firebaseSignOut
} from 'firebase/auth';
import { 
  doc, 
  getDoc, 
  setDoc, 
  collection, 
  query, 
  where, 
  getDocs 
} from 'firebase/firestore';

// Connect to MetaMask wallet
export const connectWallet = async () => {
  try {
    // Check if MetaMask is installed
    if (!window.ethereum) {
      return {
        success: false,
        address: null,
        error: 'MetaMask is not installed. Please install MetaMask to connect your wallet.'
      };
    }

    // Request account access
    const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
    
    // Get the connected wallet address
    const address = accounts[0];
    
    if (!address) {
      return {
        success: false,
        address: null,
        error: 'No accounts found. Please check MetaMask and try again.'
      };
    }
    
    // Setup listeners for account changes
    window.ethereum.on('accountsChanged', (newAccounts) => {
      // Handle account changes - You might want to refresh the page or update the state
      if (newAccounts.length === 0) {
        // User disconnected all accounts
        window.location.reload();
      } else {
        // User switched accounts
        window.location.reload();
      }
    });
    
    // Setup listeners for chain changes
    window.ethereum.on('chainChanged', () => {
      // Handle chain changes - Best practice is to reload the page
      window.location.reload();
    });
    
    return {
      success: true,
      address,
      error: null
    };
  } catch (error) {
    console.error("Error connecting MetaMask:", error);
    
    // Handle specific MetaMask errors
    if (error.code === 4001) {
      // User rejected the request
      return {
        success: false,
        address: null,
        error: 'You rejected the connection request. Please approve the MetaMask connection to continue.'
      };
    }
    
    return {
      success: false,
      address: null,
      error: error.message || 'Failed to connect wallet. Please try again.'
    };
  }
};

// Check if wallet address is associated with a registered company
export const checkCompanyExists = async (walletAddress) => {
  try {
    const companyQuery = query(
      collection(db, "companies"), 
      where("walletAddress", "==", walletAddress)
    );
    
    const querySnapshot = await getDocs(companyQuery);
    
    if (!querySnapshot.empty) {
      // Return the company data
      return {
        exists: true,
        data: querySnapshot.docs[0].data(),
        id: querySnapshot.docs[0].id
      };
    }
    
    return { exists: false };
  } catch (error) {
    console.error("Error checking company:", error);
    return { 
      exists: false, 
      error: error.message 
    };
  }
};

// Register a new company
export const registerCompany = async (companyData) => {
  try {
    // Validate email domain
    const email = companyData.email;
    const domain = email.split('@')[1];
    
    // Reject free email providers
    const freeEmailProviders = ['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com', 'aol.com', 'icloud.com'];
    if (freeEmailProviders.includes(domain)) {
      return {
        success: false,
        error: 'Please use a company email domain. Free email providers are not allowed.'
      };
    }
    
    // Check if company name already exists
    const nameQuery = query(
      collection(db, "companies"), 
      where("name", "==", companyData.name)
    );
    
    const nameQuerySnapshot = await getDocs(nameQuery);
    if (!nameQuerySnapshot.empty) {
      return {
        success: false,
        error: 'A company with this name already exists.'
      };
    }
    
    // Create a new document in the companies collection
    const companyRef = doc(collection(db, "companies"));
    await setDoc(companyRef, {
      ...companyData,
      registrationDate: new Date(),
      isVerified: false,
      tokenBalances: {
        carbonCredits: 0
      },
      transactions: []
    });
    
    return {
      success: true,
      companyId: companyRef.id
    };
  } catch (error) {
    console.error("Error registering company:", error);
    return {
      success: false,
      error: error.message
    };
  }
};

// Get company details
export const getCompanyDetails = async (companyId) => {
  try {
    const companyDoc = await getDoc(doc(db, "companies", companyId));
    
    if (companyDoc.exists()) {
      return {
        success: true,
        data: companyDoc.data()
      };
    } else {
      return {
        success: false,
        error: 'Company not found'
      };
    }
  } catch (error) {
    console.error("Error getting company details:", error);
    return {
      success: false,
      error: error.message
    };
  }
};

// Sign out
export const signOut = async () => {
  try {
    await firebaseSignOut(auth);
    return { success: true };
  } catch (error) {
    console.error("Error signing out:", error);
    return {
      success: false,
      error: error.message
    };
  }
}; 