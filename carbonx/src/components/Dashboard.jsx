import { motion } from 'framer-motion';

const Dashboard = () => {
  const stats = [
    {
      title: "Total Carbon Bridged",
      value: "21,890,661",
      unit: "TCO2"
    },
    {
      title: "Total Carbon Locked",
      value: "19,905,783",
      unit: "TCO2"
    },
    {
      title: "Total Liquidity",
      value: "1,810,027",
      unit: "USD"
    },
    {
      title: "Total Carbon Retired",
      value: "210,338",
      unit: "TCO2"
    }
  ];

  const activities = [
    {
      type: 'Purchase',
      amount: '50 Credits',
      date: 'Mar 5, 2024',
      status: 'Completed'
    },
    {
      type: 'Sale',
      amount: '20 Credits',
      date: 'Mar 4, 2024',
      status: 'Pending'
    },
    {
      type: 'Transfer',
      amount: '30 Credits',
      date: 'Mar 3, 2024',
      status: 'Completed'
    },
    {
      type: 'Purchase',
      amount: '100 Credits',
      date: 'Mar 2, 2024',
      status: 'Failed'
    }
  ];

  return (
    <>
      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        {stats.map((stat, index) => (
          <motion.div
            key={stat.title}
            className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: index * 0.1 }}
            whileHover={{ scale: 1.02 }}
          >
            <h3 className="text-[#94A3B8] text-sm mb-2">{stat.title}</h3>
            <div className="flex items-baseline">
              <span className="text-2xl font-bold text-white">{stat.value}</span>
              <span className="ml-2 text-sm text-[#76EAD7]">{stat.unit}</span>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Pool Information */}
      <div className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10 mb-8">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-xl font-bold text-white">Toucan Biochar Carbon Pool (CHAR)</h2>
          <div className="flex items-center space-x-2">
            <span className="text-3xl font-bold text-white">$147.19</span>
            <button className="btn-primary">Buy CHAR</button>
          </div>
        </div>
        <div className="space-y-4">
          <div className="flex items-center justify-between text-sm">
            <span className="text-[#94A3B8]">Pool Composition</span>
            <span className="text-white">Credits deposited into pool: 1,357 TCO2</span>
          </div>
          <div className="h-2 bg-[#1E293B] rounded-full overflow-hidden">
            <div className="h-full bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D] w-3/4"></div>
          </div>
        </div>
      </div>

      {/* Recent Activity */}
      <div className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl border border-[#76EAD7]/10 overflow-hidden">
        <div className="p-6 border-b border-[#76EAD7]/10">
          <h2 className="text-xl font-bold text-white">Recent Activity</h2>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-[#76EAD7]/10">
                <th className="px-6 py-4 text-left text-sm font-medium text-[#94A3B8]">Type</th>
                <th className="px-6 py-4 text-left text-sm font-medium text-[#94A3B8]">Amount</th>
                <th className="px-6 py-4 text-left text-sm font-medium text-[#94A3B8]">Date</th>
                <th className="px-6 py-4 text-left text-sm font-medium text-[#94A3B8]">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#76EAD7]/10">
              {activities.map((activity, index) => (
                <tr key={index} className="hover:bg-white/5">
                  <td className="px-6 py-4 text-sm text-white">{activity.type}</td>
                  <td className="px-6 py-4 text-sm text-white">{activity.amount}</td>
                  <td className="px-6 py-4 text-sm text-[#94A3B8]">{activity.date}</td>
                  <td className="px-6 py-4">
                    <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium
                      ${activity.status === 'Completed' ? 'bg-[#C4FB6D]/10 text-[#C4FB6D]' : 
                        activity.status === 'Pending' ? 'bg-yellow-400/10 text-yellow-400' :
                        'bg-red-400/10 text-red-400'
                      }`}>
                      {activity.status}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
};

export default Dashboard; 