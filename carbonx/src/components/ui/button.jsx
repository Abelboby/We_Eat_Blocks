import React from 'react';

const Button = ({ 
  children, 
  variant = 'primary', 
  size = 'md', 
  fullWidth = false, 
  href,
  icon,
  onClick,
  disabled = false,
  className = '',
  ...props 
}) => {
  const baseClasses = 'inline-flex items-center justify-center rounded-lg transition-all duration-200 font-medium focus:outline-none focus:ring-2 focus:ring-offset-2';
  
  const variantClasses = {
    primary: 'bg-gradient-to-r from-forest-500 to-carbon-600 hover:from-forest-600 hover:to-carbon-700 text-white focus:ring-forest-500 shadow-md hover:shadow-lg',
    secondary: 'bg-white dark:bg-gray-800 text-carbon-700 dark:text-carbon-300 border border-carbon-200 dark:border-carbon-700 hover:bg-gray-50 dark:hover:bg-gray-700 focus:ring-carbon-500',
    outline: 'border border-forest-500 text-forest-600 dark:text-forest-400 hover:bg-forest-50 dark:hover:bg-gray-800 focus:ring-forest-500',
    ghost: 'text-forest-600 dark:text-forest-400 hover:bg-forest-50 dark:hover:bg-gray-800 focus:ring-forest-500',
  };
  
  const sizeClasses = {
    sm: 'text-sm px-4 py-2 gap-1.5',
    md: 'text-base px-6 py-3 gap-2',
    lg: 'text-lg px-8 py-4 gap-2.5',
  };
  
  const widthClass = fullWidth ? 'w-full' : '';
  const disabledClass = disabled ? 'opacity-60 cursor-not-allowed' : '';
  
  const classes = `${baseClasses} ${variantClasses[variant]} ${sizeClasses[size]} ${widthClass} ${disabledClass} ${className}`;
  
  if (href) {
    return (
      <a href={href} className={classes} {...props}>
        {icon && <span className="inline-flex">{icon}</span>}
        {children}
      </a>
    );
  }
  
  return (
    <button 
      onClick={onClick} 
      disabled={disabled}
      className={classes} 
      {...props}
    >
      {icon && <span className="inline-flex">{icon}</span>}
      {children}
    </button>
  );
};

export default Button; 