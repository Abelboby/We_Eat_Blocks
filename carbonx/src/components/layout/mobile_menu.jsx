import React from 'react';
import Button from '../ui/button';

const MobileMenu = ({ isOpen, navLinks, onClose }) => {
  if (!isOpen) return null;

  return (
    <div className="md:hidden absolute top-16 inset-x-0 bg-white dark:bg-gray-900 shadow-lg rounded-b-2xl border-t dark:border-gray-800">
      <div className="p-4 space-y-4">
        <nav className="flex flex-col space-y-3">
          {navLinks.map((link) => (
            <a 
              key={link.name} 
              href={link.href} 
              className="font-accent text-lg py-2 text-gray-700 dark:text-gray-300 hover:text-forest-600 dark:hover:text-forest-400"
              onClick={onClose}
            >
              {link.name}
            </a>
          ))}
        </nav>
        <div className="flex flex-col space-y-2 pt-4 border-t dark:border-gray-800">
          <Button 
            variant="secondary" 
            fullWidth
            href="#login"
            onClick={onClose}
          >
            Login
          </Button>
          <Button 
            variant="primary" 
            fullWidth
            href="#get-started"
            onClick={onClose}
          >
            Get Started
          </Button>
        </div>
      </div>
    </div>
  );
};

export default MobileMenu; 