import React from 'react';
import StepCard from '../ui/step_card';

const HowItWorks = () => {
  const steps = [
    {
      id: 1,
      number: '01',
      title: 'Register & Verify',
      description: 'Create an account and complete our verification process to ensure platform security.',
      image: '/src/assets/images/step1.svg',
    },
    {
      id: 2,
      number: '02',
      title: 'Browse Projects',
      description: 'Explore a diverse range of verified carbon offset projects from around the world.',
      image: '/src/assets/images/step2.svg',
    },
    {
      id: 3,
      number: '03',
      title: 'Purchase Credits',
      description: 'Buy carbon credits directly or bid in our marketplace auctions.',
      image: '/src/assets/images/step3.svg',
    },
    {
      id: 4,
      number: '04',
      title: 'Track Impact',
      description: 'Monitor your environmental impact with detailed analytics and reporting.',
      image: '/src/assets/images/step4.svg',
    },
  ];

  return (
    <section id="how-it-works" className="py-20 relative overflow-hidden">
      {/* Background decorations */}
      <div className="absolute left-0 top-1/2 -translate-y-1/2 w-64 h-64 bg-gradient-to-br from-forest-300/20 to-forest-500/30 rounded-full blur-3xl"></div>
      <div className="absolute right-0 top-1/3 -translate-y-1/2 w-64 h-64 bg-gradient-to-br from-ocean-300/20 to-ocean-500/30 rounded-full blur-3xl"></div>
      
      <div className="container-custom relative z-10">
        <div className="text-center mb-16">
          <h2 className="section-title">
            How <span className="gradient-text">carbonX</span> Works
          </h2>
          <p className="section-subtitle">
            Our streamlined process makes carbon credit trading accessible to everyone, from individual investors to large corporations.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {steps.map((step) => (
            <StepCard
              key={step.id}
              number={step.number}
              title={step.title}
              description={step.description}
              image={step.image}
            />
          ))}
        </div>
        
        <div className="mt-16 text-center">
          <div className="inline-block animated-gradient-border">
            <div className="bg-white dark:bg-gray-800 p-6 rounded-lg">
              <h3 className="text-lg md:text-xl font-bold text-gray-900 dark:text-white mb-2">
                Ready to reduce your carbon footprint?
              </h3>
              <p className="text-gray-600 dark:text-gray-400 mb-4">
                Join thousands of environmentally conscious organizations and individuals.
              </p>
              <a 
                href="#get-started" 
                className="btn-primary"
              >
                Get Started Now
              </a>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default HowItWorks; 