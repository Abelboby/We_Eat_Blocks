import React, { useState, useEffect, useRef } from 'react';

const CountUp = ({ start = 0, end, duration = 2000, suffix = '', formattingFn = null }) => {
  const [count, setCount] = useState(start);
  const countRef = useRef(start);
  const timerRef = useRef(null);
  
  useEffect(() => {
    const step = (timestamp) => {
      if (!timerRef.current.startTime) timerRef.current.startTime = timestamp;
      const progress = timestamp - timerRef.current.startTime;
      
      const nextCount = Math.min(
        start + ((end - start) * (progress / duration)),
        end
      );
      
      countRef.current = nextCount;
      setCount(nextCount);
      
      if (progress < duration) {
        timerRef.current.id = requestAnimationFrame(step);
      }
    };
    
    timerRef.current = {};
    timerRef.current.id = requestAnimationFrame(step);
    
    return () => {
      if (timerRef.current.id) {
        cancelAnimationFrame(timerRef.current.id);
      }
    };
  }, [start, end, duration]);
  
  let displayValue = Math.floor(count);
  if (formattingFn) {
    displayValue = formattingFn(displayValue);
  }
  
  return <span>{displayValue}{suffix}</span>;
};

export default CountUp; 