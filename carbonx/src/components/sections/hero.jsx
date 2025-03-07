import React from 'react';
import Button from '../ui/button';

const Hero = () => {
  return (
    <section className="relative pt-28 pb-24 overflow-hidden">
      {/* Background decorations */}
      <div className="absolute top-0 left-0 w-96 h-96 bg-forest-400/20 dark:bg-forest-600/20 rounded-full blur-3xl -translate-x-1/2 -translate-y-1/2 opacity-70 blob"></div>
      <div className="absolute bottom-0 right-0 w-96 h-96 bg-ocean-400/20 dark:bg-ocean-600/20 rounded-full blur-3xl translate-x-1/2 translate-y-1/2 opacity-70 blob"></div>
      
      <div className="container-custom relative z-10">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          {/* Hero content */}
          <div className="text-center lg:text-left">
            <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold mb-6 leading-tight">
              Carbon Credit Trading
              <span className="block gradient-text">Reimagined</span>
            </h1>
            <p className="text-lg md:text-xl text-gray-600 dark:text-gray-300 mb-8 max-w-2xl mx-auto lg:mx-0">
              carbonX combines blockchain technology with AI verification to create the most transparent, efficient and sustainable carbon credit marketplace.
            </p>
            
            <div className="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
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
                Get Started
              </Button>
              <Button 
                variant="outline"
                size="lg"
                href="#how-it-works"
                icon={
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5">
                    <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM6.75 9.25a.75.75 0 000 1.5h4.59l-2.1 1.95a.75.75 0 001.02 1.1l3.5-3.25a.75.75 0 000-1.1l-3.5-3.25a.75.75 0 10-1.02 1.1l2.1 1.95H6.75z" clipRule="evenodd" />
                  </svg>
                }
              >
                Learn More
              </Button>
            </div>
            
            <div className="mt-8 pt-8 border-t border-gray-200 dark:border-gray-800 flex flex-wrap justify-center lg:justify-start gap-6">
              <div className="flex items-center">
                <span className="text-3xl font-bold text-carbon-700 dark:text-carbon-300 mr-2">1M+</span>
                <span className="text-sm text-gray-600 dark:text-gray-400">Carbon Credits Traded</span>
              </div>
              <div className="flex items-center">
                <span className="text-3xl font-bold text-carbon-700 dark:text-carbon-300 mr-2">50+</span>
                <span className="text-sm text-gray-600 dark:text-gray-400">Corporate Partners</span>
              </div>
              <div className="flex items-center">
                <span className="text-3xl font-bold text-carbon-700 dark:text-carbon-300 mr-2">99%</span>
                <span className="text-sm text-gray-600 dark:text-gray-400">Verification Accuracy</span>
              </div>
            </div>
          </div>
          
          {/* Hero image/illustration */}
          <div className="relative">
            <div className="absolute inset-0 bg-gradient-radial from-forest-400/20 to-transparent rounded-full blur-xl"></div>
            <div className="relative w-full max-w-lg mx-auto animate-float">
              <div className="absolute top-0 -left-4 w-72 h-72 bg-forest-400/30 dark:bg-forest-600/30 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-blob"></div>
              <div className="absolute top-0 -right-4 w-72 h-72 bg-ocean-400/30 dark:bg-ocean-600/30 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-blob animation-delay-2000"></div>
              <div className="absolute -bottom-8 left-20 w-72 h-72 bg-earth-400/30 dark:bg-earth-600/30 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-blob animation-delay-4000"></div>
              
              <img 
                src="/src/assets/images/hero-illustration.svg" 
                alt="Carbon credit trading platform" 
                className="relative z-10 w-full h-auto drop-shadow-2xl"
              />
              
              {/* Floating elements */}
              <div className="absolute top-1/4 -left-8 bg-white dark:bg-gray-800 rounded-xl p-3 shadow-lg animate-float">
                <div className="flex items-center gap-2">
                  <div className="w-8 h-8 bg-forest-500 rounded-full flex items-center justify-center text-white">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-4 h-4">
                      <path fillRule="evenodd" d="M16.403 12.652a3 3 0 000-5.304 3 3 0 00-3.75-3.751 3 3 0 00-5.305 0 3 3 0 00-3.751 3.75 3 3 0 000 5.305 3 3 0 003.75 3.751 3 3 0 005.305 0 3 3 0 003.751-3.75zm-2.546-4.46a.75.75 0 00-1.214-.883l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clipRule="evenodd" />
                    </svg>
                  </div>
                  <span className="text-sm font-medium text-gray-700 dark:text-gray-300">Verified Credit</span>
                </div>
              </div>
              
              <div className="absolute bottom-1/4 -right-8 bg-white dark:bg-gray-800 rounded-xl p-3 shadow-lg animate-float animation-delay-1000">
                <div className="flex items-center gap-2">
                  <div className="w-8 h-8 bg-ocean-500 rounded-full flex items-center justify-center text-white">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-4 h-4">
                      <path d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" />
                    </svg>
                  </div>
                  <span className="text-sm font-medium text-gray-700 dark:text-gray-300">Trusted Partners</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Hero; 