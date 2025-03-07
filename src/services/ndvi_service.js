/**
 * NDVI Analyzer API Service
 * Handles communication with the Flask backend for NDVI analysis
 */
import { fetchThroughProxy } from './cors_proxy';

// Define API configuration
const API_CONFIG = {
  BASE_URL: 'https://vegetation-analysis.onrender.com',
  ENDPOINTS: {
    ANALYZE: '/api/analyze',
    UPLOAD: '/api/upload'
  }
};

// Log the API URL being used (helpful for debugging)
console.log('Using API endpoint:', API_CONFIG.BASE_URL + API_CONFIG.ENDPOINTS.ANALYZE);

// Flag to track if we should use a proxy for subsequent requests
let shouldUseProxy = false;

/**
 * Makes a fetch request, automatically falling back to CORS proxy if direct request fails with CORS error
 * @param {string} url - The URL to fetch
 * @param {Object} options - Fetch options
 * @returns {Promise<Response>} - Fetch response
 */
const fetchWithFallback = async (url, options) => {
  // If we already know we need a proxy, use it directly
  if (shouldUseProxy) {
    return fetchThroughProxy(url, options);
  }
  
  try {
    // Try direct fetch first
    const response = await fetch(url, options);
    return response;
  } catch (error) {
    console.error('Direct fetch failed:', error);
    
    // If it's a CORS or network error, try with proxy
    if (error.message.includes('CORS') || 
        error.message.includes('Failed to fetch') || 
        error.message.includes('NetworkError')) {
      console.log('CORS issue detected, falling back to proxy');
      shouldUseProxy = true;
      return fetchThroughProxy(url, options);
    }
    
    // Otherwise, rethrow the error
    throw error;
  }
};

/**
 * Analyze an area using coordinates and optional year range
 * 
 * @param {Object} coordinates - Object containing north, south, east, west bounds
 * @param {number} startYear - Optional start year for analysis
 * @param {number} endYear - Optional end year for analysis
 * @returns {Promise} - Promise resolving to analysis results
 */
export const analyzeArea = async (coordinates, startYear, endYear) => {
  try {
    console.log('Analyzing with coordinates:', coordinates);
    
    const url = `${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.ANALYZE}`;
    const options = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        north: coordinates.north,
        south: coordinates.south,
        east: coordinates.east,
        west: coordinates.west,
        startYear,
        endYear
      }),
    };
    
    const response = await fetchWithFallback(url, options);
    
    if (!response.ok) {
      let errorMessage;
      try {
        const errorData = await response.json();
        errorMessage = errorData.error || `Request failed with status ${response.status}`;
      } catch (e) {
        errorMessage = `Request failed with status ${response.status}`;
      }
      throw new Error(errorMessage);
    }
    
    return await response.json();
  } catch (error) {
    console.error('Error analyzing area:', error);
    
    // Provide more specific error messages for different error types
    if (error.message.includes('Failed to fetch') || error.name === 'TypeError') {
      throw new Error('Cannot connect to the analysis server. Please check if the server is running and accessible.');
    } else if (error.message.includes('NetworkError') || error.message.includes('CORS')) {
      throw new Error('Network error: CORS issue detected. Make sure the backend allows requests from this domain.');
    }
    
    throw error;
  }
}; 