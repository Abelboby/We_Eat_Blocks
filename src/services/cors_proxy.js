/**
 * CORS Proxy Utilities
 * Provides fallback methods for handling CORS issues with the API
 */

// Various CORS proxy services that can be used
const CORS_PROXIES = [
  'https://corsproxy.io/?',
  'https://cors-anywhere.herokuapp.com/',
  'https://cors-proxy.htmldriven.com/?url=',
  'https://api.allorigins.win/raw?url='
];

// Current proxy index to use
let currentProxyIndex = 0;

/**
 * Gets the current CORS proxy URL
 * @returns {string} Current CORS proxy URL
 */
export const getCurrentProxy = () => {
  return CORS_PROXIES[currentProxyIndex];
};

/**
 * Cycles to the next CORS proxy in the list
 * @returns {string} The next CORS proxy URL
 */
export const cycleToNextProxy = () => {
  currentProxyIndex = (currentProxyIndex + 1) % CORS_PROXIES.length;
  return getCurrentProxy();
};

/**
 * Creates a proxy URL for the given target URL
 * @param {string} targetUrl - The target URL to proxy
 * @returns {string} The proxied URL
 */
export const createProxyUrl = (targetUrl) => {
  return `${getCurrentProxy()}${encodeURIComponent(targetUrl)}`;
};

/**
 * Fetches a URL through a CORS proxy
 * @param {string} url - The URL to fetch
 * @param {Object} options - Fetch options
 * @returns {Promise<Response>} The fetch response
 */
export const fetchThroughProxy = async (url, options = {}) => {
  try {
    const proxyUrl = createProxyUrl(url);
    console.log(`Attempting fetch through CORS proxy: ${proxyUrl}`);
    
    const response = await fetch(proxyUrl, options);
    
    if (!response.ok) {
      throw new Error(`Proxy request failed with status ${response.status}`);
    }
    
    return response;
  } catch (error) {
    console.error('Error fetching through proxy:', error);
    
    // If we've tried all proxies, give up
    if (currentProxyIndex === CORS_PROXIES.length - 1) {
      throw new Error('All CORS proxies failed. Please try again later or contact the API administrator.');
    }
    
    // Try the next proxy
    cycleToNextProxy();
    return fetchThroughProxy(url, options);
  }
};

export default {
  getCurrentProxy,
  cycleToNextProxy,
  createProxyUrl,
  fetchThroughProxy
}; 