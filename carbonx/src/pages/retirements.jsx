import { motion } from 'framer-motion';
import { useState } from 'react';

const Retirements = () => {
  const [activeTab, setActiveTab] = useState('active');

  const retirements = [
    {
      id: 'RT001',
      project: 'Amazon Rainforest Conservation',
      amount: '100 TCO2',
      status: 'Active',
      date: '2024-03-15',
      beneficiary: 'Green Earth Foundation',
      chain: 'Ethereum'
    },
    {
      id: 'RT002',
      project: 'Solar Power Initiative',
      amount: '50 TCO2',
      status: 'Completed',
      date: '2024-03-10',
      beneficiary: 'Renewable Energy Corp',
      chain: 'Polygon'
    },
    {
      id: 'RT003',
      project: 'Wind Farm Development',
      amount: '75 TCO2',
      status: 'Active',
      date: '2024-03-08',
      beneficiary: 'Clean Air Alliance',
      chain: 'Avalanche'
    },
    {
      id: 'RT004',
      project: 'Mangrove Restoration',
      amount: '200 TCO2',
      status: 'Completed',
      date: '2024-03-05',
      beneficiary: 'Ocean Conservation Inc',
      chain: 'Binance'
    }
  ];

  const filteredRetirements = retirements.filter(
    retirement => activeTab === 'all' || retirement.status.toLowerCase() === activeTab
  );

  return (
    <>
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-white mb-2">Carbon Retirements</h1>
        <p className="text-[#94A3B8]">Track and manage your carbon credit retirements</p>
      </div>

      {/* Stats */}
      <motion.div
        className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
      >
        <div className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/10 p-6">
          <h3 className="text-[#94A3B8] text-sm mb-2">Total Retired</h3>
          <p className="text-2xl font-bold text-white">425 TCO2</p>
        </div>
        <div className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/10 p-6">
          <h3 className="text-[#94A3B8] text-sm mb-2">Active Retirements</h3>
          <p className="text-2xl font-bold text-white">2</p>
        </div>
        <div className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/10 p-6">
          <h3 className="text-[#94A3B8] text-sm mb-2">Completed</h3>
          <p className="text-2xl font-bold text-white">2</p>
        </div>
      </motion.div>

      {/* Filters */}
      <motion.div
        className="flex space-x-4 mb-6"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1 }}
      >
        {['all', 'active', 'completed'].map(tab => (
          <button
            key={tab}
            onClick={() => setActiveTab(tab)}
            className={`px-4 py-2 rounded-xl text-sm font-medium transition-colors
              ${activeTab === tab
                ? 'bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] text-black'
                : 'text-[#94A3B8] hover:text-white'
              }`}
          >
            {tab.charAt(0).toUpperCase() + tab.slice(1)}
          </button>
        ))}
      </motion.div>

      {/* Retirements Table */}
      <motion.div
        className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/10 overflow-hidden"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
      >
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-[#76EAD7]/10">
                <th className="px-6 py-4 text-left text-sm font-medium text-[#94A3B8]">ID</th>
                <th className="px-6 py-4 text-left text-sm font-medium text-[#94A3B8]">Project</th>
                <th className="px-6 py-4 text-left text-sm font-medium text-[#94A3B8]">Amount</th>
                <th className="px-6 py-4 text-left text-sm font-medium text-[#94A3B8]">Status</th>
                <th className="px-6 py-4 text-left text-sm font-medium text-[#94A3B8]">Date</th>
                <th className="px-6 py-4 text-left text-sm font-medium text-[#94A3B8]">Beneficiary</th>
                <th className="px-6 py-4 text-left text-sm font-medium text-[#94A3B8]">Chain</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#76EAD7]/10">
              {filteredRetirements.map((retirement) => (
                <tr key={retirement.id} className="hover:bg-white/5">
                  <td className="px-6 py-4">
                    <span className="text-sm text-[#76EAD7]">{retirement.id}</span>
                  </td>
                  <td className="px-6 py-4 text-sm text-white">{retirement.project}</td>
                  <td className="px-6 py-4 text-sm text-white">{retirement.amount}</td>
                  <td className="px-6 py-4">
                    <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium
                      ${retirement.status === 'Active'
                        ? 'bg-[#76EAD7]/10 text-[#76EAD7]'
                        : 'bg-[#C4FB6D]/10 text-[#C4FB6D]'
                      }`}>
                      {retirement.status}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-sm text-[#94A3B8]">{retirement.date}</td>
                  <td className="px-6 py-4 text-sm text-[#94A3B8]">{retirement.beneficiary}</td>
                  <td className="px-6 py-4 text-sm text-[#94A3B8]">{retirement.chain}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </motion.div>

      {/* New Retirement Button */}
      <motion.div
        className="fixed bottom-8 right-8"
        initial={{ opacity: 0, scale: 0.8 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ delay: 0.3 }}
      >
        <button className="bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] text-black font-bold py-3 px-6 rounded-xl hover:opacity-90 transition-opacity flex items-center space-x-2">
          <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
          </svg>
          <span>New Retirement</span>
        </button>
      </motion.div>
    </>
  );
};

export default Retirements; 