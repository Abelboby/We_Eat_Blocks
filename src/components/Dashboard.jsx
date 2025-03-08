import { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { Link } from 'react-router-dom';
import { useWallet } from '../context/wallet_context';
import { 
  getVerifiedReports, 
  getPendingReports, 
  getTokenBalance,
  getVerifiedReportsWithCoordinates
} from '../services/carbon_contract_service';
import { getAllCompanies } from '../services/auth_service';

const Dashboard = () => {
  const { walletAddress } = useWallet();
  const [stats, setStats] = useState([
    { title: "Total Carbon Credits", value: "—", unit: "TCO2" },
    { title: "Verified Reports", value: "—", unit: "Reports" },
    { title: "Active Companies", value: "—", unit: "Entities" },
    { title: "Your Credit Balance", value: "—", unit: "TCO2" }
  ]);
  
  const [activities, setActivities] = useState([]);
  const [recentReports, setRecentReports] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [categoryDistribution, setCategoryDistribution] = useState({});
  
  useEffect(() => {
    const fetchDashboardData = async () => {
      setIsLoading(true);
      try {
        // Fetch verified reports
        const reportsResult = await getVerifiedReports();
        const reports = reportsResult.success ? reportsResult.reports : [];
        
        // Fetch pending reports
        const pendingResult = await getPendingReports();
        const pendingReports = pendingResult.success ? pendingResult.reports : [];
        
        // Fetch companies
        const companiesResult = await getAllCompanies();
        const companies = companiesResult.success ? companiesResult.companies : [];
        const verifiedCompanies = companies.filter(c => c.verificationStatus === 'approved');
        
        // Fetch user token balance if wallet connected
        let userBalance = "0";
        if (walletAddress) {
          const balanceResult = await getTokenBalance(walletAddress);
          userBalance = balanceResult.success ? balanceResult.balance : "0";
        }
        
        // Calculate total carbon credits (simplified)
        const totalTokens = reports.reduce((total, report) => {
          return total + parseInt(report.mintedTokens || 0);
        }, 0);
        
        // Get recent verified reports
        const sortedReports = [...reports].sort((a, b) => 
          parseInt(b.timestamp) - parseInt(a.timestamp)
        ).slice(0, 5);
        
        // Map company addresses to names
        const companyMap = {};
        companies.forEach(company => {
          if (company.walletAddress) {
            companyMap[company.walletAddress.toLowerCase()] = company.name;
          }
        });
        
        // Prepare recent reports with company names
        const recentReportsWithCompanies = sortedReports.map(report => {
          const companyName = companyMap[report.reporter.toLowerCase()] || 'Unknown Company';
          return {
            ...report,
            companyName
          };
        });
        
        // Calculate category distribution
        const categories = {};
        reports.forEach(report => {
          const category = report.category || 'Uncategorized';
          if (!categories[category]) {
            categories[category] = 0;
          }
          categories[category]++;
        });
        
        // Create activities from reports and other events
        const formattedActivities = sortedReports.map(report => {
          const date = new Date(parseInt(report.timestamp) * 1000);
          const formattedDate = date.toLocaleDateString();
          return {
            type: 'Verification',
            description: `${report.title} verified`,
            amount: `${report.mintedTokens || '0'} Credits`,
            date: formattedDate,
            company: companyMap[report.reporter.toLowerCase()] || 'Unknown',
            status: 'Completed'
          };
        });
        
        // Update state with fetched data
        setStats([
          { title: "Total Carbon Credits", value: totalTokens.toLocaleString(), unit: "TCO2" },
          { title: "Verified Reports", value: reports.length.toLocaleString(), unit: "Reports" },
          { title: "Active Companies", value: verifiedCompanies.length.toLocaleString(), unit: "Entities" },
          { title: "Your Credit Balance", value: parseInt(userBalance).toLocaleString(), unit: "TCO2" }
        ]);
        
        setRecentReports(recentReportsWithCompanies);
        setActivities(formattedActivities);
        setCategoryDistribution(categories);
      } catch (error) {
        console.error("Error fetching dashboard data:", error);
      } finally {
        setIsLoading(false);
      }
    };
    
    fetchDashboardData();
  }, [walletAddress]);
  
  const getCategoryColors = (category) => {
    const colorMap = {
      'Renewable Energy': { bg: 'bg-blue-500/10', text: 'text-blue-400', gradient: 'from-blue-500 to-blue-300' },
      'Waste Reduction': { bg: 'bg-purple-500/10', text: 'text-purple-400', gradient: 'from-purple-500 to-purple-300' },
      'Carbon Offset': { bg: 'bg-[#76EAD7]/10', text: 'text-[#76EAD7]', gradient: 'from-[#76EAD7] to-[#C4FB6D]' },
      'Sustainable Agriculture': { bg: 'bg-green-500/10', text: 'text-green-400', gradient: 'from-green-500 to-green-300' },
      'Forest Conservation': { bg: 'bg-emerald-500/10', text: 'text-emerald-400', gradient: 'from-emerald-500 to-emerald-300' },
      'Ocean Conservation': { bg: 'bg-cyan-500/10', text: 'text-cyan-400', gradient: 'from-cyan-500 to-cyan-300' },
      'Clean Water Initiative': { bg: 'bg-sky-500/10', text: 'text-sky-400', gradient: 'from-sky-500 to-sky-300' },
      'Biodiversity Protection': { bg: 'bg-amber-500/10', text: 'text-amber-400', gradient: 'from-amber-500 to-amber-300' },
      'Circular Economy': { bg: 'bg-teal-500/10', text: 'text-teal-400', gradient: 'from-teal-500 to-teal-300' },
      'Sustainable Transportation': { bg: 'bg-indigo-500/10', text: 'text-indigo-400', gradient: 'from-indigo-500 to-indigo-300' }
    };
    
    return colorMap[category] || { bg: 'bg-gray-500/10', text: 'text-gray-400', gradient: 'from-gray-500 to-gray-300' };
  };
  
  // Format date
  const formatDate = (timestamp) => {
    const date = new Date(parseInt(timestamp) * 1000);
    return date.toLocaleDateString();
  };

  return (
    <>
      <div className="mb-8">
        <motion.h1 
          className="text-3xl font-bold text-white mb-2 gradient-text"
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
        >
          Carbon Credit Dashboard
        </motion.h1>
        <motion.p 
          className="text-[#94A3B8]"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.5, delay: 0.1 }}
        >
          Monitor carbon credit activities and environmental impact across the network
        </motion.p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        {stats.map((stat, index) => (
          <motion.div
            key={stat.title}
            className="stats-card relative bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: index * 0.1 }}
            whileHover={{ scale: 1.02 }}
            style={{ '--animation-order': index }}
          >
            <h3 className="text-[#94A3B8] text-sm mb-2">{stat.title}</h3>
            <div className="flex items-baseline">
              <span className="text-2xl font-bold text-white">{stat.value}</span>
              <span className="ml-2 text-sm text-[#76EAD7]">{stat.unit}</span>
            </div>
            
            {/* Decorative background element */}
            <div className="absolute top-3 right-3 opacity-20">
              <div className="icon-glow w-8 h-8">
                {index === 0 && (
                  <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12 2L2 7L12 12L22 7L12 2Z" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                    <path d="M2 17L12 22L22 17" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                    <path d="M2 12L12 17L22 12" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                  </svg>
                )}
                {index === 1 && (
                  <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M16 4H8C5.79086 4 4 5.79086 4 8V16C4 18.2091 5.79086 20 8 20H16C18.2091 20 20 18.2091 20 16V8C20 5.79086 18.2091 4 16 4Z" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                    <path d="M9 12L11 14L15 10" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                  </svg>
                )}
                {index === 2 && (
                  <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M17 21V19C17 17.9391 16.5786 16.9217 15.8284 16.1716C15.0783 15.4214 14.0609 15 13 15H5C3.93913 15 2.92172 15.4214 2.17157 16.1716C1.42143 16.9217 1 17.9391 1 19V21" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                    <path d="M9 11C11.2091 11 13 9.20914 13 7C13 4.79086 11.2091 3 9 3C6.79086 3 5 4.79086 5 7C5 9.20914 6.79086 11 9 11Z" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                    <path d="M23 21V19C22.9993 18.1137 22.7044 17.2528 22.1614 16.5523C21.6184 15.8519 20.8581 15.3516 20 15.13" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                    <path d="M16 3.13C16.8604 3.35031 17.623 3.85071 18.1676 4.55232C18.7122 5.25392 19.0078 6.11683 19.0078 7.005C19.0078 7.89318 18.7122 8.75608 18.1676 9.45769C17.623 10.1593 16.8604 10.6597 16 10.88" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                  </svg>
                )}
                {index === 3 && (
                  <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12 1V23" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                    <path d="M17 5H9.5C8.57174 5 7.6815 5.36875 7.02513 6.02513C6.36875 6.6815 6 7.57174 6 8.5C6 9.42826 6.36875 10.3185 7.02513 10.9749C7.6815 11.6313 8.57174 12 9.5 12H14.5C15.4283 12 16.3185 12.3687 16.9749 13.0251C17.6313 13.6815 18 14.5717 18 15.5C18 16.4283 17.6313 17.3185 16.9749 17.9749C16.3185 18.6313 15.4283 19 14.5 19H6" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                  </svg>
                )}
              </div>
            </div>
          </motion.div>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
        {/* Category Distribution */}
        <motion.div 
          className="lg:col-span-1 bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10"
          initial={{ opacity: 0, x: -20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.5, delay: 0.2 }}
        >
          <h2 className="text-xl font-bold text-white mb-4">Sustainability Categories</h2>
          
          {isLoading ? (
            <div className="flex items-center justify-center h-48">
              <div className="animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-[#76EAD7]"></div>
            </div>
          ) : (
            <div className="space-y-3">
              {Object.entries(categoryDistribution)
                .sort((a, b) => b[1] - a[1])
                .slice(0, 6)
                .map(([category, count]) => {
                  const colors = getCategoryColors(category);
                  const percentage = Math.round((count / recentReports.length) * 100);
                  
                  return (
                    <div key={category} className="space-y-1">
                      <div className="flex justify-between items-center text-sm">
                        <span className={`${colors.text} font-medium`}>{category}</span>
                        <span className="text-white">{count} reports</span>
                      </div>
                      <div className="h-2 bg-[#0F172A] rounded-full overflow-hidden">
                        <motion.div 
                          className={`h-full bg-gradient-to-r ${colors.gradient}`}
                          initial={{ width: 0 }}
                          animate={{ width: `${percentage}%` }}
                          transition={{ duration: 1, delay: 0.5 }}
                        ></motion.div>
                      </div>
                    </div>
                  );
                })}
              
              <div className="mt-4 pt-4 border-t border-[#76EAD7]/10">
                <Link to="/carbon-pools" className="text-sm text-[#76EAD7] hover:text-[#C4FB6D] flex items-center">
                  <span>View all sustainability categories</span>
                  <svg className="w-4 h-4 ml-1" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M5 12H19" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                    <path d="M12 5L19 12L12 19" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                  </svg>
                </Link>
              </div>
            </div>
          )}
        </motion.div>
        
        {/* Recent Reports Card */}
        <motion.div 
          className="lg:col-span-2 bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10"
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.5, delay: 0.3 }}
        >
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-bold text-white">Recent Reports</h2>
            <Link to="/companies" className="text-sm text-[#76EAD7] hover:text-[#C4FB6D] flex items-center">
              <span>View all</span>
              <svg className="w-4 h-4 ml-1" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M5 12H19" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                <path d="M12 5L19 12L12 19" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
            </Link>
          </div>
          
          {isLoading ? (
            <div className="flex items-center justify-center h-48">
              <div className="animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-[#76EAD7]"></div>
            </div>
          ) : recentReports.length === 0 ? (
            <div className="text-center py-10">
              <svg className="w-12 h-12 mx-auto text-[#94A3B8] opacity-50" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 12H15" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                <path d="M12 9V15" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                <path d="M3 12C3 13.1819 3.23279 14.3522 3.68508 15.4442C4.13738 16.5361 4.80031 17.5282 5.63604 18.364C6.47177 19.1997 7.46392 19.8626 8.55585 20.3149C9.64778 20.7672 10.8181 21 12 21C13.1819 21 14.3522 20.7672 15.4442 20.3149C16.5361 19.8626 17.5282 19.1997 18.364 18.364C19.1997 17.5282 19.8626 16.5361 20.3149 15.4442C20.7672 14.3522 21 13.1819 21 12C21 9.61305 20.0518 7.32387 18.364 5.63604C16.6761 3.94821 14.3869 3 12 3C9.61305 3 7.32387 3.94821 5.63604 5.63604C3.94821 7.32387 3 9.61305 3 12Z" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
              <p className="mt-4 text-[#94A3B8]">No verified reports yet</p>
            </div>
          ) : (
            <div className="space-y-4">
              {recentReports.map((report, index) => {
                const colors = getCategoryColors(report.category);
                
                return (
                  <motion.div
                    key={report.id}
                    className="feature-card-enhanced bg-[#0F172A]/80 rounded-lg p-4 flex items-start space-x-4"
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: 0.4 + (index * 0.1) }}
                    style={{ '--animation-order': index }}
                  >
                    <div className={`feature-icon-enhanced ${colors.bg} p-3 rounded-lg ${colors.text}`}>
                      <svg className="w-6 h-6" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M9 11L12 14L22 4" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                        <path d="M21 12V19C21 19.5304 20.7893 20.0391 20.4142 20.4142C20.0391 20.7893 19.5304 21 19 21H5C4.46957 21 3.96086 20.7893 3.58579 20.4142C3.21071 20.0391 3 19.5304 3 19V5C3 4.46957 3.21071 3.96086 3.58579 3.58579C3.96086 3.21071 4.46957 3 5 3H16" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                      </svg>
                    </div>
                    
                    <div className="flex-1">
                      <div className="flex justify-between">
                        <h3 className="text-white font-medium">{report.title}</h3>
                        <span className={`text-xs ${colors.text}`}>{report.category}</span>
                      </div>
                      <p className="text-[#94A3B8] text-sm mt-1">By {report.companyName}</p>
                      <div className="flex justify-between items-center mt-2">
                        <span className="text-xs text-[#94A3B8]">
                          {formatDate(report.timestamp)}
                        </span>
                        <span className="text-xs font-medium text-[#C4FB6D]">
                          {parseInt(report.mintedTokens || 0).toLocaleString()} TCO2
                        </span>
                      </div>
                    </div>
                  </motion.div>
                );
              })}
              
              <Link to="/companies" className="block text-center text-sm text-[#76EAD7] hover:text-[#C4FB6D] mt-4 py-2">
                View all verified reports
              </Link>
            </div>
          )}
        </motion.div>
      </div>

      {/* CTA / Resources Card */}
      <motion.div
        className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10 mb-8"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5, delay: 0.4 }}
      >
        <div className="flex flex-col md:flex-row items-center justify-between">
          <div>
            <h2 className="text-xl font-bold text-white mb-2">Analyze Environmental Impact</h2>
            <p className="text-[#94A3B8] max-w-2xl">
              Use our NDVI Analyzer to assess vegetation health and changes over time in areas where sustainability projects are being implemented.
            </p>
          </div>
          <Link 
            to="/ndvi-analyzer" 
            className="mt-4 md:mt-0 px-6 py-3 bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] text-black font-semibold rounded-lg hover:from-[#C4FB6D] hover:to-[#76EAD7] transition-all duration-300"
          >
            Launch NDVI Analyzer
          </Link>
        </div>
      </motion.div>
    </>
  );
};

export default Dashboard; 