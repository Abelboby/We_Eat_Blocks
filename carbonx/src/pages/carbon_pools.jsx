import { motion } from 'framer-motion';

const CarbonPools = () => {
  const pools = [
    {
      name: 'Toucan Biochar Carbon Pool',
      symbol: 'CHAR',
      price: '$147.19',
      tvl: '1,357 TCO2',
      change: '+5.2%'
    },
    {
      name: 'Nature Carbon Pool',
      symbol: 'NCT',
      price: '$98.45',
      tvl: '2,845 TCO2',
      change: '+3.8%'
    },
    {
      name: 'Base Carbon Pool',
      symbol: 'BCT',
      price: '$125.30',
      tvl: '1,932 TCO2',
      change: '-2.1%'
    }
  ];

  return (
    <>
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-white mb-2">Carbon Pools</h1>
        <p className="text-[#94A3B8]">Explore and interact with various carbon credit pools</p>
      </div>

      <div className="grid gap-6">
        {pools.map((pool, index) => (
          <motion.div
            key={pool.symbol}
            className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: index * 0.1 }}
            whileHover={{ scale: 1.01 }}
          >
            <div className="flex items-center justify-between mb-6">
              <div>
                <h2 className="text-xl font-bold text-white mb-1">{pool.name}</h2>
                <span className="text-sm text-[#94A3B8]">{pool.symbol}</span>
              </div>
              <div className="flex items-center space-x-4">
                <div className="text-right">
                  <span className="block text-2xl font-bold text-white">{pool.price}</span>
                  <span className={`text-sm ${
                    pool.change.startsWith('+') ? 'text-[#C4FB6D]' : 'text-red-400'
                  }`}>{pool.change}</span>
                </div>
                <button className="btn-primary">Trade</button>
              </div>
            </div>
            <div className="space-y-4">
              <div className="flex items-center justify-between text-sm">
                <span className="text-[#94A3B8]">Total Value Locked</span>
                <span className="text-white">{pool.tvl}</span>
              </div>
              <div className="h-2 bg-[#1E293B] rounded-full overflow-hidden">
                <div 
                  className="h-full bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D]" 
                  style={{ width: `${Math.random() * 40 + 60}%` }}
                />
              </div>
            </div>
          </motion.div>
        ))}
      </div>
    </>
  );
};

export default CarbonPools; 