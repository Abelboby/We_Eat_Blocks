import React from 'react';
import Button from '../ui/button';

const CTA = () => {
  return (
    <section className="py-20 relative overflow-hidden">
      {/* Background decorations */}
      <div className="absolute inset-0 bg-gradient-to-br from-forest-500/5 to-ocean-500/5 dark:from-forest-900/20 dark:to-ocean-900/20"></div>
      <div className="absolute left-0 top-1/2 -translate-y-1/2 w-64 h-64 bg-forest-400/20 dark:bg-forest-600/20 rounded-full blur-3xl"></div>
      <div className="absolute right-0 top-1/4 w-64 h-64 bg-ocean-400/20 dark:bg-ocean-600/20 rounded-full blur-3xl"></div>
      
      <div className="container-custom relative z-10">
        <div className="max-w-4xl mx-auto text-center card-glass p-8 md:p-12">
          <h2 className="text-3xl md:text-4xl font-bold mb-6 text-gray-900 dark:text-white">
            Ready to Make a <span className="gradient-text">Positive Impact</span> on Our Planet?
          </h2>
          <p className="text-lg text-gray-700 dark:text-gray-300 mb-8 max-w-2xl mx-auto">
            Join thousands of organizations and individuals who are already trading carbon credits and making a difference with carbonX.
          </p>
          
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Button 
              variant="primary" 
              size="lg"
              href="#get-started"
              icon={
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5">
                  <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clipRule="evenodd" />
                </svg>
              }
            >
              Start Trading Now
            </Button>
            <Button 
              variant="outline"
              size="lg"
              href="#contact"
              icon={
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5">
                  <path fillRule="evenodd" d="M10 3a1.5 1.5 0 00-1.5 1.5v1.5a1.5 1.5 0 001.5 1.5h1.5a1.5 1.5 0 001.5-1.5V4.5A1.5 1.5 0 0011.5 3h-1.5zM10 12a1.5 1.5 0 00-1.5 1.5v1.5a1.5 1.5 0 001.5 1.5h1.5a1.5 1.5 0 001.5-1.5v-1.5a1.5 1.5 0 00-1.5-1.5h-1.5zM3 7.5a1.5 1.5 0 011.5-1.5h1.5a1.5 1.5 0 011.5 1.5v1.5a1.5 1.5 0 01-1.5 1.5H4.5a1.5 1.5 0 01-1.5-1.5v-1.5zM3 16.5a1.5 1.5 0 011.5-1.5h1.5a1.5 1.5 0 011.5 1.5v1.5a1.5 1.5 0 01-1.5 1.5H4.5a1.5 1.5 0 01-1.5-1.5v-1.5z" clipRule="evenodd" />
                </svg>
              }
            >
              Contact Sales
            </Button>
          </div>
          
          <p className="text-sm text-gray-600 dark:text-gray-400 mt-6">
            No credit card required. Free basic account available.
          </p>
        </div>
      </div>
    </section>
  );
};

export default CTA; 