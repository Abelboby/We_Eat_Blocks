import React from 'react';

const FeatureCard = ({ title, description, icon }) => {
  return (
    <div className="card p-6 hover:translate-y-[-5px] transition-all duration-300">
      <div className="flex items-center justify-center w-12 h-12 mb-5 rounded-xl bg-gradient-to-br from-forest-500/20 to-carbon-600/20 text-forest-600 dark:text-forest-400">
        {icon}
      </div>
      <h3 className="text-xl font-bold mb-3 text-gray-900 dark:text-white">{title}</h3>
      <p className="text-gray-600 dark:text-gray-400">{description}</p>
    </div>
  );
};

export default FeatureCard; 