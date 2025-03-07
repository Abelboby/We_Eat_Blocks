import React from 'react';
import Header from './components/layout/header';
import Footer from './components/layout/footer';
import Hero from './components/sections/hero';
import HowItWorks from './components/sections/how_it_works';
import Features from './components/sections/features';
import Stats from './components/sections/stats';
import Testimonials from './components/sections/testimonials';
import CTA from './components/sections/cta';
import Partners from './components/sections/partners';

function App() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-gray-50 to-white dark:from-gray-900 dark:to-gray-800">
      <Header />
      <main className="overflow-hidden">
        <Hero />
        <Features />
        <HowItWorks />
        <Stats />
        <Testimonials />
        <Partners />
        <CTA />
      </main>
      <Footer />
    </div>
  );
}

export default App;
