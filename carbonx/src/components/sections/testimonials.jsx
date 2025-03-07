import React, { useState } from 'react';
import TestimonialCard from '../ui/testimonial_card';

const Testimonials = () => {
  const [activeIndex, setActiveIndex] = useState(0);
  
  const testimonials = [
    {
      id: 1,
      quote: "carbonX revolutionized how we approach carbon offsetting. The transparency and verification features give us complete confidence in our environmental investments.",
      author: "Sarah Johnson",
      title: "Sustainability Director",
      company: "GreenTech Innovations",
      avatar: "/src/assets/images/testimonial-1.jpg",
    },
    {
      id: 2,
      quote: "As a company committed to net-zero emissions, carbonX has been instrumental in helping us achieve our goals. Their AI verification is truly game-changing.",
      author: "Michael Chen",
      title: "CEO",
      company: "EcoSystems Global",
      avatar: "/src/assets/images/testimonial-2.jpg",
    },
    {
      id: 3,
      quote: "The real-time trading and analytics dashboard have made managing our carbon portfolio effortless. We've reduced our carbon footprint by 40% in just one year.",
      author: "Emma Rodriguez",
      title: "Environmental Strategy Lead",
      company: "Sustainable Future Inc.",
      avatar: "/src/assets/images/testimonial-3.jpg",
    },
  ];
  
  const handleNext = () => {
    setActiveIndex((prevIndex) => 
      prevIndex === testimonials.length - 1 ? 0 : prevIndex + 1
    );
  };
  
  const handlePrev = () => {
    setActiveIndex((prevIndex) => 
      prevIndex === 0 ? testimonials.length - 1 : prevIndex - 1
    );
  };
  
  return (
    <section id="testimonials" className="py-20 bg-gray-50 dark:bg-gray-900">
      <div className="container-custom">
        <div className="text-center mb-16">
          <h2 className="section-title">
            What Our <span className="gradient-text">Clients Say</span>
          </h2>
          <p className="section-subtitle">
            Trusted by leading companies and environmental organizations around the world.
          </p>
        </div>
        
        <div className="relative max-w-4xl mx-auto">
          <div className="carousel overflow-hidden">
            <div 
              className="flex transition-transform duration-500 ease-in-out"
              style={{ transform: `translateX(-${activeIndex * 100}%)` }}
            >
              {testimonials.map((testimonial) => (
                <div key={testimonial.id} className="w-full flex-shrink-0">
                  <TestimonialCard 
                    quote={testimonial.quote}
                    author={testimonial.author}
                    title={testimonial.title}
                    company={testimonial.company}
                    avatar={testimonial.avatar}
                  />
                </div>
              ))}
            </div>
          </div>
          
          <div className="flex justify-center mt-8 space-x-2">
            {testimonials.map((_, index) => (
              <button
                key={index}
                onClick={() => setActiveIndex(index)}
                className={`w-3 h-3 rounded-full transition-all ${
                  index === activeIndex
                    ? 'bg-forest-500 w-8'
                    : 'bg-gray-300 dark:bg-gray-700'
                }`}
                aria-label={`Go to slide ${index + 1}`}
              />
            ))}
          </div>

          <button
            onClick={handlePrev}
            className="absolute top-1/2 -left-4 md:-left-12 -translate-y-1/2 bg-white dark:bg-gray-800 rounded-full p-3 shadow-lg text-gray-800 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700"
            aria-label="Previous testimonial"
          >
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5">
              <path fillRule="evenodd" d="M12.79 5.23a.75.75 0 01-.02 1.06L8.832 10l3.938 3.71a.75.75 0 11-1.04 1.08l-4.5-4.25a.75.75 0 010-1.08l4.5-4.25a.75.75 0 011.06.02z" clipRule="evenodd" />
            </svg>
          </button>

          <button
            onClick={handleNext}
            className="absolute top-1/2 -right-4 md:-right-12 -translate-y-1/2 bg-white dark:bg-gray-800 rounded-full p-3 shadow-lg text-gray-800 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700"
            aria-label="Next testimonial"
          >
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5">
              <path fillRule="evenodd" d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z" clipRule="evenodd" />
            </svg>
          </button>
        </div>
      </div>
    </section>
  );
};

export default Testimonials; 