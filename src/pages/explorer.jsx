import { motion } from 'framer-motion';

const Explorer = () => {
  const transactions = [
    {
      hash: '0x1234...5678',
      type: 'Bridge',
      amount: '100 TCO2',
      from: '0xabc...def',
      to: '0x789...012',
      time: '2 mins ago'
    },
    {
      hash: '0x8765...4321',
      type: 'Retire',
      amount: '50 TCO2',
      from: '0xfed...cba',
      to: '0x345...678',
      time: '5 mins ago'
    },
    {
      hash: '0x2468...1357',
      type: 'Trade',
      amount: '75 TCO2',
      from: '0x123...456',
      to: '0x789...abc',
      time: '10 mins ago'
    },
    {
      hash: '0x1357...2468',
      type: 'Bridge',
      amount: '200 TCO2',
      from: '0xdef...789',
      to: '0x012...345',
      time: '15 mins ago'
    }
  ];

  return (
    <>
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-white mb-2">Explorer</h1>
        <p className="text-[#94A3B8]">Track carbon credit transactions and movements</p>
      </div>

      {/* Search Bar */}
      <motion.div
        className="mb-8"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
      >
        <div className="relative">
          <input
            type="text"
            placeholder="Search by transaction hash, address, or token"
            className="w-full bg-[#1E293B]/50 backdrop-blur-xl rounded-xl px-4 py-3 text-white border border-[#76EAD7]/10 focus:border-[#76EAD7]/50 focus:outline-none"
          />
          <button className="absolute right-3 top-1/2 -translate-y-1/2">
            <svg className="w-5 h-5 text-[#94A3B8]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </button>
        </div>
      </motion.div>

      {/* Transactions Table */}
      <motion.div
        className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/10 overflow-hidden"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1 }}
      >
        <div className="p-6 border-b border-[#76EAD7]/10">
          <h2 className="text-xl font-bold text-white">Recent Transactions</h2>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-[#76EAD7]/10">
                <th className="px-6 py-4 text-left text-sm font-medium text-[#94A3B8]">Tx Hash</th>
                <th className="px-6 py-4 text-left text-sm font-medium text-[#94A3B8]">Type</th>
                <th className="px-6 py-4 text-left text-sm font-medium text-[#94A3B8]">Amount</th>
                <th className="px-6 py-4 text-left text-sm font-medium text-[#94A3B8]">From</th>
                <th className="px-6 py-4 text-left text-sm font-medium text-[#94A3B8]">To</th>
                <th className="px-6 py-4 text-left text-sm font-medium text-[#94A3B8]">Time</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#76EAD7]/10">
              {transactions.map((tx, index) => (
                <tr key={index} className="hover:bg-white/5">
                  <td className="px-6 py-4">
                    <span className="text-sm text-[#76EAD7]">{tx.hash}</span>
                  </td>
                  <td className="px-6 py-4">
                    <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium
                      ${tx.type === 'Bridge' ? 'bg-[#76EAD7]/10 text-[#76EAD7]' : 
                        tx.type === 'Retire' ? 'bg-[#C4FB6D]/10 text-[#C4FB6D]' :
                        'bg-purple-400/10 text-purple-400'
                      }`}>
                      {tx.type}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-sm text-white">{tx.amount}</td>
                  <td className="px-6 py-4 text-sm text-[#94A3B8]">{tx.from}</td>
                  <td className="px-6 py-4 text-sm text-[#94A3B8]">{tx.to}</td>
                  <td className="px-6 py-4 text-sm text-[#94A3B8]">{tx.time}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </motion.div>
    </>
  );
};

export default Explorer; 