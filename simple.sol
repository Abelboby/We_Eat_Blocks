// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Ownable.sol";

contract SimpleReportContract is Ownable {
    struct Report {
        address reporter;
        string title;
        string description;
        string category;
        string evidence;
        uint256 timestamp;
        string date;
        int256 latitude;
        int256 longitude;
        string latDirection;
        string longDirection;
        uint256 mintedTokens;
        bool verified;
    }

    // Mapping to store token balances for each address
    mapping(address => uint256) public tokenBalances;
    
    // Mapping to store citizen token balances for each address
    mapping(address => uint256) public citizenTokens;
    
    // Tokens owned by the contract (available for sale)
    uint256 public contractTokenBalance;
    
    // Arrays to store pending and verified reports
    Report[] public pendingReports;
    Report[] public verifiedReports;

    // Token prices in wei (1 ETH = 10^18 wei)
    uint256 public tokenBuyPrice;   // How much ETH to pay for 1 token
    uint256 public tokenSellPrice;  // How much ETH to receive for 1 token when selling
    
    // Total supply of tokens
    uint256 public totalTokenSupply;

    // Structure to store token transaction details
    struct TokenTransaction {
        address account;          // Address involved in transaction
        uint256 amount;          // Amount of tokens
        uint256 price;           // Price in wei
        uint256 timestamp;       // When the transaction occurred
        TransactionType txType;  // Type of transaction
    }

    // Enum to identify transaction types
    enum TransactionType {
        BUY,        // Buying tokens from contract
        SELL,       // Selling tokens to contract
        REWARD,     // Tokens received from verified report
        CITIZEN     // Citizen tokens received
    }

    // Mapping to store all transactions for each address
    mapping(address => TokenTransaction[]) private tokenTransactionHistory;

    event ReportSubmitted(address indexed reporter, string title, string category);
    event ReportVerified(address indexed reporter, uint256 tokensMinted);
    event TokensAdded(address indexed account, uint256 amount);
    event CitizenTokensAdded(address indexed account, uint256 amount);
    event TokensBought(address indexed buyer, uint256 amount, uint256 cost);
    event TokensSold(address indexed seller, uint256 amount, uint256 payout);
    event TokensMinted(address indexed minter, uint256 amount);
    event PricesUpdated(uint256 buyPrice, uint256 sellPrice);
    event EthWithdrawn(address indexed to, uint256 amount);
    event EthDeposited(address indexed from, uint256 amount);

    constructor() Ownable(msg.sender) {
        // Set token prices in wei
        tokenBuyPrice = 10000000000000;  // 0.00001 ETH to buy 1 token
        tokenSellPrice = 10000000000000; // 0.00001 ETH when selling 1 token
        totalTokenSupply = 0;
        contractTokenBalance = 0;
    }
    
    // Submit a report - anyone can submit
    function submitReport(
        string memory title,
        string memory description,
        string memory category,
        string memory evidence,
        string memory date,
        int256 latitude,
        int256 longitude,
        string memory latDirection,
        string memory longDirection
    ) external {
        pendingReports.push(Report({
            reporter: msg.sender,
            title: title,
            description: description,
            category: category,
            evidence: evidence,
            timestamp: block.timestamp,
            date: date,
            latitude: latitude,
            longitude: longitude,
            latDirection: latDirection,
            longDirection: longDirection,
            mintedTokens: 0,
            verified: false
        }));
        
        emit ReportSubmitted(msg.sender, title, category);
    }
    
    // Verify a report and mint tokens - only owner can verify
    function verifyReport(uint256 reportIndex, uint256 tokensToMint) external onlyOwner {
        require(reportIndex < pendingReports.length, "Invalid report index");
        
        Report memory report = pendingReports[reportIndex];
        require(!report.verified, "Already verified");
        
        // Mint tokens to the reporter
        tokenBalances[report.reporter] += tokensToMint;
        totalTokenSupply += tokensToMint;
        
        // Record transaction
        tokenTransactionHistory[report.reporter].push(TokenTransaction({
            account: report.reporter,
            amount: tokensToMint,
            price: 0, // Reward tokens have no price
            timestamp: block.timestamp,
            txType: TransactionType.REWARD
        }));
        
        // Update report
        report.verified = true;
        report.mintedTokens = tokensToMint;
        
        // Add to verified reports
        verifiedReports.push(report);
        
        // Remove from pending reports (swap and pop to save gas)
        pendingReports[reportIndex] = pendingReports[pendingReports.length - 1];
        pendingReports.pop();
        
        emit ReportVerified(report.reporter, tokensToMint);
        emit TokensAdded(report.reporter, tokensToMint);
        emit TokensMinted(report.reporter, tokensToMint);
    }
    
    // Add citizen tokens to an address - only owner can add tokens
    function addCitizenTokens(address account, uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than zero");
        citizenTokens[account] += amount;

        // Record transaction
        tokenTransactionHistory[account].push(TokenTransaction({
            account: account,
            amount: amount,
            price: 0, // Citizen tokens have no price
            timestamp: block.timestamp,
            txType: TransactionType.CITIZEN
        }));

        emit CitizenTokensAdded(account, amount);
    }
    
    // Get citizen token balance of an address
    function getCitizenTokenBalance(address account) external view returns (uint256) {
        return citizenTokens[account];
    }
    
    // Get all pending reports
    function getPendingReports() external view returns (Report[] memory) {
        return pendingReports;
    }
    
    // Get all verified reports
    function getVerifiedReports() external view returns (Report[] memory) {
        return verifiedReports;
    }
    
    // Get token balance of an address
    function getTokenBalance(address account) external view returns (uint256) {
        return tokenBalances[account];
    }
    
    // Get pending reports count
    function getPendingReportsCount() external view returns (uint256) {
        return pendingReports.length;
    }
    
    // Get verified reports count
    function getVerifiedReportsCount() external view returns (uint256) {
        return verifiedReports.length;
    }
    
    // Set token prices - only owner can set prices
    function setTokenPrices(uint256 newBuyPrice, uint256 newSellPrice) external onlyOwner {
        require(newBuyPrice > 0, "Buy price must be greater than zero");
        require(newSellPrice > 0, "Sell price must be greater than zero");
        require(newBuyPrice >= newSellPrice, "Buy price must be greater than or equal to sell price");
        
        tokenBuyPrice = newBuyPrice;
        tokenSellPrice = newSellPrice;
        
        emit PricesUpdated(newBuyPrice, newSellPrice);
    }
    
    // Buy tokens with ETH - uses tokens from contract balance only
    function buyTokens() external payable {
        require(msg.value > 0, "Must send ETH to buy tokens");
        require(tokenBuyPrice > 0, "Token buy price not set");
        
        uint256 tokenAmount = msg.value / tokenBuyPrice;
        require(tokenAmount > 0, "Not enough ETH to buy at least one token");
        require(tokenAmount <= contractTokenBalance, "Not enough tokens available for sale");
        
        // Calculate actual cost (refund any excess ETH)
        uint256 cost = tokenAmount * tokenBuyPrice;
        
        // Refund excess ETH if any
        if (msg.value > cost) {
            payable(msg.sender).transfer(msg.value - cost);
        }
        
        // Transfer tokens from contract to buyer
        contractTokenBalance -= tokenAmount;
        tokenBalances[msg.sender] += tokenAmount;
        
        // Record transaction
        tokenTransactionHistory[msg.sender].push(TokenTransaction({
            account: msg.sender,
            amount: tokenAmount,
            price: cost,
            timestamp: block.timestamp,
            txType: TransactionType.BUY
        }));
        
        emit TokensBought(msg.sender, tokenAmount, cost);
    }
    
    // Sell tokens to the contract for ETH
    function sellTokens(uint256 tokenAmount) external {
        require(tokenAmount > 0, "Amount must be greater than zero");
        
        // Check combined balance of regular tokens and citizen tokens
        uint256 regularTokens = tokenBalances[msg.sender];
        uint256 citizenTokenBalance = citizenTokens[msg.sender];
        uint256 totalTokens = regularTokens + citizenTokenBalance;
        
        require(totalTokens >= tokenAmount, "Not enough tokens");
        require(tokenSellPrice > 0, "Token sell price not set");
        
        uint256 ethAmount = tokenAmount * tokenSellPrice;
        require(address(this).balance >= ethAmount, "Contract doesn't have enough ETH");
        
        // First use regular tokens, then citizen tokens if needed
        if (tokenAmount <= regularTokens) {
            // If regular tokens are enough, just use them
            tokenBalances[msg.sender] -= tokenAmount;
        } else {
            // Use all regular tokens and remaining from citizen tokens
            uint256 remainingAmount = tokenAmount - regularTokens;
            tokenBalances[msg.sender] = 0;
            citizenTokens[msg.sender] -= remainingAmount;
        }
        
        contractTokenBalance += tokenAmount;
        
        // Record transaction
        tokenTransactionHistory[msg.sender].push(TokenTransaction({
            account: msg.sender,
            amount: tokenAmount,
            price: ethAmount,
            timestamp: block.timestamp,
            txType: TransactionType.SELL
        }));
        
        // Send ETH to seller
        payable(msg.sender).transfer(ethAmount);
        
        emit TokensSold(msg.sender, tokenAmount, ethAmount);
    }
    
    // Withdraw ETH from contract - only owner can withdraw
    function withdrawEth(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than zero");
        require(address(this).balance >= amount, "Not enough ETH in contract");
        
        payable(msg.sender).transfer(amount);
        
        emit EthWithdrawn(msg.sender, amount);
    }
    
    // Get contract ETH balance
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    // Get contract token balance
    function getContractTokenBalance() external view returns (uint256) {
        return contractTokenBalance;
    }
    
    // Get total token supply
    function getTotalTokenSupply() external view returns (uint256) {
        return totalTokenSupply;
    }
    
    // Deposit ETH into the contract without buying tokens
    function deposit() external payable {
        require(msg.value > 0, "Must send ETH to deposit");
        emit EthDeposited(msg.sender, msg.value);
    }
    
    // Fallback function to receive ETH when no specific function is called
    fallback() external payable {
        emit EthDeposited(msg.sender, msg.value);
    }
    
    // Receive function to receive ETH
    receive() external payable {
        emit EthDeposited(msg.sender, msg.value);
    }

    // Get all token transactions for an account
    function getTokenTransactionHistory(address account) external view returns (TokenTransaction[] memory) {
        return tokenTransactionHistory[account];
    }

    // Get number of transactions for an account
    function getTransactionCount(address account) external view returns (uint256) {
        return tokenTransactionHistory[account].length;
    }

    // Get specific transaction details
    function getTransaction(address account, uint256 index) external view returns (
        uint256 amount,
        uint256 price,
        uint256 timestamp,
        TransactionType txType
    ) {
        require(index < tokenTransactionHistory[account].length, "Transaction index out of bounds");
        TokenTransaction memory Tx = tokenTransactionHistory[account][index];
        return (Tx.amount, Tx.price, Tx.timestamp, Tx.txType);
    }
}