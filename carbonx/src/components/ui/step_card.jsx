import React from 'react';

const StepCard = ({ number, title, description, image }) => {
  return (
    <div className="card overflow-hidden hover:translate-y-[-5px] transition-all duration-300">
      <div className="relative h-48 bg-gradient-to-br from-forest-50 to-ocean-50 dark:from-forest-900/20 dark:to-ocean-900/20 flex items-center justify-center">
        <span className="absolute top-3 right-4 text-4xl font-bold opacity-20 text-forest-600 dark:text-forest-400">{number}</span>
        <img src={image} alt={title} className="max-h-32 w-auto relative z-10" />
      </div>
      <div className="p-6">
        <h3 className="text-xl font-bold mb-3 text-gray-900 dark:text-white">{title}</h3>
        <p className="text-gray-600 dark:text-gray-400">{description}</p>
      </div>
    </div>
  );
};

export default StepCard; 