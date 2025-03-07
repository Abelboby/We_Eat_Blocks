import { motion } from 'framer-motion';
import { useState } from 'react';

const CrossChain = () => {
  const [selectedChain, setSelectedChain] = useState('Ethereum');
  
  const chains = [
    {
      name: 'Ethereum',
      icon: '🌐',
      balance: '1,000 TCO2',
      bridgeFee: '0.01 ETH'
    },
    {
      name: 'Polygon',
      icon: '⭕',
      balance: '5,000 TCO2',
      bridgeFee: '0.1 MATIC'
    },
    {
      name: 'Avalanche',
      icon: '❄️',
      balance: '2,500 TCO2',
      bridgeFee: '0.1 AVAX'
    },
    {
      name: 'Binance',
      icon: '🟡',
      balance: '3,000 TCO2',
      bridgeFee: '0.005 BNB'
    }
  ];

  return (
    <>
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-white mb-2">Cross Chain Bridge</h1>
        <p className="text-[#94A3B8]">Bridge your carbon credits across different blockchains</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Bridge Form */}
        <motion.div
          className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/10 p-6"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
        >
          <h2 className="text-xl font-bold text-white mb-6">Bridge Assets</h2>
          
          <div className="space-y-6">
            <div>
              <label className="block text-sm font-medium text-[#94A3B8] mb-2">From Chain</label>
              <select 
                className="w-full bg-[#1E293B] rounded-xl px-4 py-3 text-white border border-[#76EAD7]/10 focus:border-[#76EAD7]/50 focus:outline-none"
                value={selectedChain}
                onChange={(e) => setSelectedChain(e.target.value)}
              >
                {chains.map(chain => (
                  <option key={chain.name} value={chain.name}>
                    {chain.icon} {chain.name}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium text-[#94A3B8] mb-2">To Chain</label>
              <select 
                className="w-full bg-[#1E293B] rounded-xl px-4 py-3 text-white border border-[#76EAD7]/10 focus:border-[#76EAD7]/50 focus:outline-none"
              >
                {chains.filter(chain => chain.name !== selectedChain).map(chain => (
                  <option key={chain.name} value={chain.name}>
                    {chain.icon} {chain.name}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium text-[#94A3B8] mb-2">Amount</label>
              <div className="relative">
                <input
                  type="text"
                  placeholder="0.0"
                  className="w-full bg-[#1E293B] rounded-xl px-4 py-3 text-white border border-[#76EAD7]/10 focus:border-[#76EAD7]/50 focus:outline-none"
                />
                <span className="absolute right-4 top-1/2 -translate-y-1/2 text-[#94A3B8]">TCO2</span>
              </div>
            </div>

            <button className="w-full bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] text-black font-bold py-3 px-4 rounded-xl hover:opacity-90 transition-opacity">
              Bridge Assets
            </button>
          </div>
        </motion.div>

        {/* Chain Info */}
        <motion.div
          className="space-y-6"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
        >
          {chains.map((chain, index) => (
            <div
              key={chain.name}
              className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/10 p-6"
            >
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center space-x-3">
                  <span className="text-2xl">{chain.icon}</span>
                  <h3 className="text-lg font-bold text-white">{chain.name}</h3>
                </div>
                <span className="text-[#76EAD7]">{chain.balance}</span>
              </div>
              <div className="flex justify-between text-sm">
                <span className="text-[#94A3B8]">Bridge Fee</span>
                <span className="text-white">{chain.bridgeFee}</span>
              </div>
            </div>
          ))}
        </motion.div>
      </div>
    </>
  );
};

export default CrossChain; 