import React from 'react';
import Logo from '../ui/logo';
import SocialLinks from '../ui/social_links';

const Footer = () => {
  const currentYear = new Date().getFullYear();
  
  const footerLinks = [
    {
      title: 'Product',
      links: [
        { name: 'Features', href: '#features' },
        { name: 'How It Works', href: '#how-it-works' },
        { name: 'Pricing', href: '#pricing' },
        { name: 'Case Studies', href: '#case-studies' },
      ]
    },
    {
      title: 'Company',
      links: [
        { name: 'About Us', href: '#about' },
        { name: 'Careers', href: '#careers' },
        { name: 'Press', href: '#press' },
        { name: 'Partners', href: '#partners' },
      ]
    },
    {
      title: 'Resources',
      links: [
        { name: 'Blog', href: '#blog' },
        { name: 'Documentation', href: '#docs' },
        { name: 'Carbon Credits', href: '#credits' },
        { name: 'Sustainability', href: '#sustainability' },
      ]
    },
    {
      title: 'Support',
      links: [
        { name: 'Help Center', href: '#help' },
        { name: 'Contact Us', href: '#contact' },
        { name: 'Privacy', href: '#privacy' },
        { name: 'Terms', href: '#terms' },
      ]
    }
  ];

  return (
    <footer className="bg-gray-50 dark:bg-gray-900 border-t border-gray-200 dark:border-gray-800">
      <div className="container-custom py-12">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-8">
          {/* Brand Column */}
          <div className="lg:col-span-1">
            <Logo />
            <p className="mt-4 text-gray-600 dark:text-gray-400 text-sm">
              Revolutionizing carbon credit trading with blockchain technology and AI verification systems.
            </p>
            <div className="mt-6">
              <SocialLinks />
            </div>
          </div>
          
          {/* Links Columns */}
          {footerLinks.map((column) => (
            <div key={column.title}>
              <h3 className="font-accent font-bold text-gray-900 dark:text-white mb-4">
                {column.title}
              </h3>
              <ul className="space-y-3">
                {column.links.map((link) => (
                  <li key={link.name}>
                    <a 
                      href={link.href}
                      className="text-gray-600 dark:text-gray-400 hover:text-forest-600 dark:hover:text-forest-400 text-sm transition-colors"
                    >
                      {link.name}
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>
        
        <div className="mt-12 pt-8 border-t border-gray-200 dark:border-gray-800 flex flex-col md:flex-row justify-between items-center">
          <p className="text-gray-600 dark:text-gray-400 text-sm">
            © {currentYear} carbonX. All rights reserved.
          </p>
          <div className="mt-4 md:mt-0 flex space-x-6">
            <a href="#privacy" className="text-gray-600 dark:text-gray-400 hover:text-forest-600 dark:hover:text-forest-400 text-sm">
              Privacy Policy
            </a>
            <a href="#terms" className="text-gray-600 dark:text-gray-400 hover:text-forest-600 dark:hover:text-forest-400 text-sm">
              Terms of Service
            </a>
            <a href="#cookies" className="text-gray-600 dark:text-gray-400 hover:text-forest-600 dark:hover:text-forest-400 text-sm">
              Cookies
            </a>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer; 