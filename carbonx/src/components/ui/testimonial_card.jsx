import React from 'react';

const TestimonialCard = ({ quote, author, title, company, avatar }) => {
  return (
    <div className="card p-8 text-center">
      <div className="mb-6">
        <svg className="w-10 h-10 mx-auto text-forest-400" fill="currentColor" viewBox="0 0 24 24">
          <path d="M14.017 21v-7.391c0-5.704 3.731-9.57 8.983-10.609l.995 2.151c-2.432.917-3.995 3.638-3.995 5.849h4v10h-9.983zm-14.017 0v-7.391c0-5.704 3.748-9.57 9-10.609l.996 2.151c-2.433.917-3.996 3.638-3.996 5.849h3.983v10h-9.983z" />
        </svg>
      </div>
      
      <p className="text-lg text-gray-700 dark:text-gray-300 mb-8">{quote}</p>
      
      <div className="flex items-center justify-center">
        <img 
          src={avatar} 
          alt={author} 
          className="w-14 h-14 rounded-full border-2 border-forest-400 object-cover mr-4"
        />
        <div className="text-left">
          <h4 className="font-bold text-gray-900 dark:text-white">{author}</h4>
          <p className="text-sm text-gray-600 dark:text-gray-400">{title}, {company}</p>
        </div>
      </div>
    </div>
  );
};

export default TestimonialCard; 