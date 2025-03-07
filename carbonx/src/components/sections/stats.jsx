import React from 'react';
import CountUp from '../ui/count_up';

const Stats = () => {
  const stats = [
    {
      id: 1,
      value: 1000000,
      suffix: '+',
      label: 'Carbon Credits Traded',
      icon: (
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-7 h-7">
          <path d="M21 6.375c0 2.692-4.03 4.875-9 4.875S3 9.067 3 6.375 7.03 1.5 12 1.5s9 2.183 9 4.875z" />
          <path d="M12 12.75c-4.97 0-9-2.184-9-4.875v6.75c0 2.691 4.03 4.875 9 4.875s9-2.184 9-4.875v-6.75c0 2.691-4.03 4.875-9 4.875z" />
        </svg>
      ),
    },
    {
      id: 2,
      value: 500,
      suffix: '+',
      label: 'Verified Projects',
      icon: (
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-7 h-7">
          <path fillRule="evenodd" d="M8.603 3.799A4.49 4.49 0 0112 2.25c1.357 0 2.573.6 3.397 1.549a4.49 4.49 0 013.498 1.307 4.491 4.491 0 011.307 3.497A4.49 4.49 0 0121.75 12a4.49 4.49 0 01-1.549 3.397 4.491 4.491 0 01-1.307 3.497 4.491 4.491 0 01-3.497 1.307A4.49 4.49 0 0112 21.75a4.49 4.49 0 01-3.397-1.549 4.49 4.49 0 01-3.498-1.306 4.491 4.491 0 01-1.307-3.498A4.49 4.49 0 012.25 12c0-1.357.6-2.573 1.549-3.397a4.49 4.49 0 011.307-3.497 4.49 4.49 0 013.497-1.307zm7.007 6.387a.75.75 0 10-1.22-.872l-3.236 4.53-2.516-2.515a.75.75 0 00-1.06 1.06l3.05 3.05a.75.75 0 001.116-.094l3.866-5.159z" clipRule="evenodd" />
        </svg>
      ),
    },
    {
      id: 3,
      value: 99,
      suffix: '%',
      label: 'Verification Accuracy',
      icon: (
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-7 h-7">
          <path fillRule="evenodd" d="M2.25 12c0-5.385 4.365-9.75 9.75-9.75s9.75 4.365 9.75 9.75-4.365 9.75-9.75 9.75S2.25 17.385 2.25 12zm13.36-1.814a.75.75 0 10-1.22-.872l-3.236 4.53L9.53 12.22a.75.75 0 00-1.06 1.06l2.25 2.25a.75.75 0 001.14-.094l3.75-5.25z" clipRule="evenodd" />
        </svg>
      ),
    },
    {
      id: 4,
      value: 5000000,
      suffix: '+',
      label: 'Tons of CO₂ Offset',
      icon: (
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-7 h-7">
          <path fillRule="evenodd" d="M12.963 2.286a.75.75 0 00-1.071-.136 9.742 9.742 0 00-3.539 6.177A7.547 7.547 0 016.648 6.61a.75.75 0 00-1.152.082A9 9 0 1015.68 4.534a7.46 7.46 0 01-2.717-2.248zM15.75 14.25a3.75 3.75 0 11-7.313-1.172c.628.465 1.35.81 2.133 1a5.99 5.99 0 011.925-3.545 3.75 3.75 0 013.255 3.717z" clipRule="evenodd" />
        </svg>
      ),
    },
  ];

  return (
    <section className="py-16 bg-gradient-to-r from-forest-600 to-carbon-700 text-white">
      <div className="container-custom">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {stats.map((stat) => (
            <div key={stat.id} className="text-center">
              <div className="bg-white/10 rounded-2xl p-6 backdrop-blur-sm hover:bg-white/20 transition-all">
                <div className="inline-flex items-center justify-center w-16 h-16 bg-white/20 rounded-full mb-4">
                  <div className="text-white">
                    {stat.icon}
                  </div>
                </div>
                <h3 className="text-4xl font-bold mb-2">
                  <CountUp 
                    end={stat.value} 
                    suffix={stat.suffix} 
                    formattingFn={(value) => {
                      if (value >= 1000000) {
                        return (value / 1000000).toFixed(1) + 'M';
                      } else if (value >= 1000) {
                        return (value / 1000).toFixed(0) + 'K';
                      }
                      return value;
                    }}
                  />
                </h3>
                <p className="text-lg text-white/80">{stat.label}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Stats; 