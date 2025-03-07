import React from 'react';

const Partners = () => {
  const partners = [
    {
      id: 1,
      name: 'EcoTech Solutions',
      logo: '/src/assets/images/partner-1.svg',
    },
    {
      id: 2,
      name: 'Green Energy Partners',
      logo: '/src/assets/images/partner-2.svg',
    },
    {
      id: 3,
      name: 'Sustainable Futures',
      logo: '/src/assets/images/partner-3.svg',
    },
    {
      id: 4,
      name: 'CleanTech Innovators',
      logo: '/src/assets/images/partner-4.svg',
    },
    {
      id: 5,
      name: 'EarthFirst Capital',
      logo: '/src/assets/images/partner-5.svg',
    },
    {
      id: 6,
      name: 'Carbon Neutral Group',
      logo: '/src/assets/images/partner-6.svg',
    },
  ];

  return (
    <section id="partners" className="py-16 bg-white dark:bg-gray-800">
      <div className="container-custom">
        <div className="text-center mb-10">
          <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">
            Trusted by Industry Leaders
          </h2>
          <p className="text-gray-600 dark:text-gray-400">
            We partner with forward-thinking companies committed to environmental sustainability
          </p>
        </div>

        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-8">
          {partners.map((partner) => (
            <div key={partner.id} className="flex items-center justify-center">
              <img 
                src={partner.logo} 
                alt={partner.name} 
                className="max-h-12 opacity-70 hover:opacity-100 transition-opacity grayscale hover:grayscale-0 filter"
              />
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Partners; 