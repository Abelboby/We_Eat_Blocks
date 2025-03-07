/**
 * NDVI Analyzer API Service
 * Handles communication with the Flask backend for NDVI analysis
 */

// Base API URL - adjust this to match your Flask backend URL
const API_BASE_URL = 'http://127.0.0.1:5000/api';

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
    const response = await fetch(`${API_BASE_URL}/analyze`, {
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
    });
    
    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.error || 'Failed to analyze area');
    }
    
    return await response.json();
  } catch (error) {
    console.error('Error analyzing area:', error);
    throw error;
  }
}; 