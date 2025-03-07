import { ethers } from 'ethers';

// Contract details
const CONTRACT_ADDRESS = '0x6A65cDE51c8ABD644b5C3ddD7797804b2544E279';
const CONTRACT_ABI = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "account",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "addCitizenTokens",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "buyTokens",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "deposit",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "account",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "CitizenTokensAdded",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "from",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "EthDeposited",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "EthWithdrawn",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "previousOwner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "OwnershipTransferred",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "buyPrice",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "sellPrice",
				"type": "uint256"
			}
		],
		"name": "PricesUpdated",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "reporter",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "title",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "category",
				"type": "string"
			}
		],
		"name": "ReportSubmitted",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "reporter",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "tokensMinted",
				"type": "uint256"
			}
		],
		"name": "ReportVerified",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "tokenAmount",
				"type": "uint256"
			}
		],
		"name": "sellTokens",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "newBuyPrice",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "newSellPrice",
				"type": "uint256"
			}
		],
		"name": "setTokenPrices",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "title",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "description",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "category",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "evidence",
				"type": "string"
			},
			{
				"internalType": "int256",
				"name": "latitude",
				"type": "int256"
			},
			{
				"internalType": "int256",
				"name": "longitude",
				"type": "int256"
			},
			{
				"internalType": "string",
				"name": "latDirection",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "longDirection",
				"type": "string"
			}
		],
		"name": "submitReport",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "account",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "TokensAdded",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "buyer",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "cost",
				"type": "uint256"
			}
		],
		"name": "TokensBought",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "minter",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "TokensMinted",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "seller",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "payout",
				"type": "uint256"
			}
		],
		"name": "TokensSold",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "transferOwnership",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"stateMutability": "payable",
		"type": "fallback"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "reportIndex",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "tokensToMint",
				"type": "uint256"
			}
		],
		"name": "verifyReport",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "withdrawEth",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"stateMutability": "payable",
		"type": "receive"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "citizenTokens",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "contractTokenBalance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "account",
				"type": "address"
			}
		],
		"name": "getCitizenTokenBalance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getContractBalance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getContractTokenBalance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getPendingReports",
		"outputs": [
			{
				"components": [
					{
						"internalType": "address",
						"name": "reporter",
						"type": "address"
					},
					{
						"internalType": "string",
						"name": "title",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "description",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "category",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "evidence",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "timestamp",
						"type": "uint256"
					},
					{
						"internalType": "int256",
						"name": "latitude",
						"type": "int256"
					},
					{
						"internalType": "int256",
						"name": "longitude",
						"type": "int256"
					},
					{
						"internalType": "string",
						"name": "latDirection",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "longDirection",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "mintedTokens",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "verified",
						"type": "bool"
					}
				],
				"internalType": "struct SimpleReportContract.Report[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getPendingReportsCount",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "account",
				"type": "address"
			}
		],
		"name": "getTokenBalance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "account",
				"type": "address"
			}
		],
		"name": "getTokenTransactionHistory",
		"outputs": [
			{
				"components": [
					{
						"internalType": "address",
						"name": "account",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "amount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "price",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "timestamp",
						"type": "uint256"
					},
					{
						"internalType": "enum SimpleReportContract.TransactionType",
						"name": "txType",
						"type": "uint8"
					}
				],
				"internalType": "struct SimpleReportContract.TokenTransaction[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getTotalTokenSupply",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "account",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "index",
				"type": "uint256"
			}
		],
		"name": "getTransaction",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "price",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			},
			{
				"internalType": "enum SimpleReportContract.TransactionType",
				"name": "txType",
				"type": "uint8"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "account",
				"type": "address"
			}
		],
		"name": "getTransactionCount",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getVerifiedReports",
		"outputs": [
			{
				"components": [
					{
						"internalType": "address",
						"name": "reporter",
						"type": "address"
					},
					{
						"internalType": "string",
						"name": "title",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "description",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "category",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "evidence",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "timestamp",
						"type": "uint256"
					},
					{
						"internalType": "int256",
						"name": "latitude",
						"type": "int256"
					},
					{
						"internalType": "int256",
						"name": "longitude",
						"type": "int256"
					},
					{
						"internalType": "string",
						"name": "latDirection",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "longDirection",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "mintedTokens",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "verified",
						"type": "bool"
					}
				],
				"internalType": "struct SimpleReportContract.Report[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getVerifiedReportsCount",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "pendingReports",
		"outputs": [
			{
				"internalType": "address",
				"name": "reporter",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "title",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "description",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "category",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "evidence",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			},
			{
				"internalType": "int256",
				"name": "latitude",
				"type": "int256"
			},
			{
				"internalType": "int256",
				"name": "longitude",
				"type": "int256"
			},
			{
				"internalType": "string",
				"name": "latDirection",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "longDirection",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "mintedTokens",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "verified",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "tokenBalances",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "tokenBuyPrice",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "tokenSellPrice",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "totalTokenSupply",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "verifiedReports",
		"outputs": [
			{
				"internalType": "address",
				"name": "reporter",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "title",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "description",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "category",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "evidence",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			},
			{
				"internalType": "int256",
				"name": "latitude",
				"type": "int256"
			},
			{
				"internalType": "int256",
				"name": "longitude",
				"type": "int256"
			},
			{
				"internalType": "string",
				"name": "latDirection",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "longDirection",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "mintedTokens",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "verified",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
];

// Get contract instance
const getContract = async () => {
  if (!window.ethereum) {
    throw new Error('MetaMask is not installed');
  }

  try {
    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();
    
    // Check if we're on the right network (Sepolia)
    const network = await provider.getNetwork();
    if (network.chainId !== 11155111n) { // Sepolia chainId
      console.warn('Warning: Not connected to Sepolia testnet');
    }
    
    return new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, signer);
  } catch (error) {
    console.error('Error getting contract instance:', error);
    throw error;
  }
};

// Submit a sustainability report
export const submitSustainabilityReport = async (reportData) => {
  try {
    // Destructure with aliases to match both naming conventions
    const { 
      title, 
      description, 
      category, 
      evidenceLink, // New name
      evidence, // Old name
      latitudeValue, // New name
      latitude, // Old name
      longitudeValue, // New name
      longitude, // Old name
      latitudeDirection, // New name
      latDirection, // Old name
      longitudeDirection, // New name
      longDirection // Old name
    } = reportData;

    // Validate inputs
    if (!title || !description || !category) {
      throw new Error('Missing required fields');
    }

    // Get contract instance
    const contract = await getContract();

    // Select the right values with fallbacks
    const evidenceUrl = evidenceLink || evidence || '';
    const lat = latitudeValue || latitude || '0';
    const long = longitudeValue || longitude || '0';
    const latDir = latitudeDirection || latDirection || 'N';
    const longDir = longitudeDirection || longDirection || 'E';

    // Safely parse latitude and longitude to int256
    let latInt = 0;
    let longInt = 0;
    
    try {
      // Make sure we're dealing with strings before using replace
      latInt = parseInt(String(lat).replace('.', ''));
      if (isNaN(latInt)) latInt = 0;
    } catch (error) {
      console.warn('Error parsing latitude:', error);
      latInt = 0;
    }
    
    try {
      // Make sure we're dealing with strings before using replace
      longInt = parseInt(String(long).replace('.', ''));
      if (isNaN(longInt)) longInt = 0;
    } catch (error) {
      console.warn('Error parsing longitude:', error);
      longInt = 0;
    }

    // Submit the report with safe values
    const tx = await contract.submitReport(
      title,
      description,
      category,
      evidenceUrl,
      latInt,
      longInt,
      latDir,
      longDir
    );

    // Wait for transaction to be mined
    const receipt = await tx.wait();

    return {
      success: true,
      txHash: receipt.hash,
      error: null
    };
  } catch (error) {
    console.error('Error submitting sustainability report:', error);
    return {
      success: false,
      txHash: null,
      error: error.message || 'Failed to submit report'
    };
  }
};

// Get all pending reports
export const getPendingReports = async () => {
  try {
    const contract = await getContract();
    
    // Use a try-catch for the specific contract call
    try {
      const reports = await contract.getPendingReports();
      
      // Safely process the reports data to handle potential missing fields
      let processedReports = [];
      if (Array.isArray(reports)) {
        processedReports = reports.map(report => {
          try {
            // Create a safe report object with default values for missing properties
            return {
              id: report.id?.toString() || '0',
              reporter: report.reporter || '0x0000000000000000000000000000000000000000',
              title: report.title || 'Untitled Report',
              description: report.description || '',
              category: report.category || 'Uncategorized',
              timestamp: report.timestamp?.toString() || '0',
              evidenceLink: report.evidenceLink || '',
              latitudeValue: report.latitudeValue?.toString() || '0',
              latitudeDirection: report.latitudeDirection || 'N',
              longitudeValue: report.longitudeValue?.toString() || '0',
              longitudeDirection: report.longitudeDirection || 'E',
              status: report.status || 0
            };
          } catch (e) {
            console.error('Error processing report data:', e);
            return null;
          }
        }).filter(report => report !== null);
      }
      
      return {
        success: true,
        reports: processedReports,
        error: null
      };
    } catch (contractError) {
      console.error('Contract call error for getPendingReports:', contractError);
      return {
        success: false,
        reports: [],
        error: 'Failed to retrieve reports from the contract. The contract may not be properly deployed on Sepolia testnet.'
      };
    }
  } catch (error) {
    console.error('Error getting pending reports:', error);
    return {
      success: false,
      reports: [],
      error: error.message || 'Failed to get pending reports'
    };
  }
};

// Get all verified reports
export const getVerifiedReports = async () => {
  try {
    const contract = await getContract();
    
    // Use a try-catch for the specific contract call
    try {
      const reports = await contract.getVerifiedReports();
      
      // Safely process the reports data to handle potential missing fields
      let processedReports = [];
      if (Array.isArray(reports)) {
        processedReports = reports.map(report => {
          try {
            // Create a safe report object with default values for missing properties
            return {
              id: report.id?.toString() || '0',
              reporter: report.reporter || '0x0000000000000000000000000000000000000000',
              title: report.title || 'Untitled Report',
              description: report.description || '',
              category: report.category || 'Uncategorized',
              timestamp: report.timestamp?.toString() || '0',
              evidenceLink: report.evidenceLink || '',
              latitudeValue: report.latitudeValue?.toString() || '0',
              latitudeDirection: report.latitudeDirection || 'N',
              longitudeValue: report.longitudeValue?.toString() || '0',
              longitudeDirection: report.longitudeDirection || 'E',
              status: report.status || 0,
              verificationResult: report.verificationResult || false,
              verificationTimestamp: report.verificationTimestamp?.toString() || '0',
              verifierNotes: report.verifierNotes || ''
            };
          } catch (e) {
            console.error('Error processing report data:', e);
            return null;
          }
        }).filter(report => report !== null);
      }
      
      return {
        success: true,
        reports: processedReports,
        error: null
      };
    } catch (contractError) {
      console.error('Contract call error for getVerifiedReports:', contractError);
      return {
        success: false,
        reports: [],
        error: 'Failed to retrieve reports from the contract. The contract may not be properly deployed on Sepolia testnet.'
      };
    }
  } catch (error) {
    console.error('Error getting verified reports:', error);
    return {
      success: false,
      reports: [],
      error: error.message || 'Failed to get verified reports'
    };
  }
};

// Get token balance
export const getTokenBalance = async (address) => {
  try {
    const contract = await getContract();
    const balance = await contract.getTokenBalance(address);
    
    return {
      success: true,
      balance: balance.toString(),
      error: null
    };
  } catch (error) {
    console.error('Error getting token balance:', error);
    return {
      success: false,
      balance: '0',
      error: error.message || 'Failed to get token balance'
    };
  }
};

// Verify a report (admin only)
export const verifyReport = async (reportIndex, tokensToMint) => {
  try {
    const contract = await getContract();
    
    // Ensure proper conversion of tokensToMint to a BigNumber
    const tokensAmount = ethers.utils.parseEther(tokensToMint.toString());
    
    const tx = await contract.verifyReport(reportIndex, tokensAmount);
    await tx.wait();
    
    return {
      success: true,
      error: null,
      transaction: tx
    };
  } catch (error) {
    console.error('Error verifying report:', error);
    return {
      success: false,
      error: error.message || 'Failed to verify report. Please ensure you have admin rights.',
      transaction: null
    };
  }
}; 