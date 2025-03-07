import { useState, useEffect, useRef } from 'react';
import { motion } from 'framer-motion';
import { MapContainer, TileLayer, Rectangle, useMap } from 'react-leaflet';
import { analyzeArea } from '../services/ndvi_service';
import 'leaflet/dist/leaflet.css';
import 'leaflet-draw/dist/leaflet.draw.css';
import L from 'leaflet';
import 'leaflet-draw';

// Fix Leaflet icon issues with webpack
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-icon-2x.png',
  iconUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-icon.png',
  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-shadow.png',
});

// Helper component to set map bounds
const MapBoundsUpdater = ({ bounds }) => {
  const map = useMap();
  
  useEffect(() => {
    if (bounds) {
      const latLngBounds = L.latLngBounds(
        [bounds.south, bounds.west],
        [bounds.north, bounds.east]
      );
      map.fitBounds(latLngBounds);
    }
  }, [map, bounds]);
  
  return null;
};

// Helper component to add drawing controls to the map
const DrawControls = ({ onRectangleDrawn }) => {
  const map = useMap();
  
  useEffect(() => {
    // Create feature group for drawn items
    const drawnItems = new L.FeatureGroup();
    map.addLayer(drawnItems);
    
    // Initialize draw control
    const drawControl = new L.Control.Draw({
      draw: {
        polyline: false,
        polygon: false,
        circle: false,
        marker: false,
        circlemarker: false,
        rectangle: {
          shapeOptions: {
            color: '#76EAD7',
            weight: 2,
            opacity: 1,
            fillOpacity: 0.3,
            fillColor: '#76EAD7'
          },
          metric: true,
          showArea: false,
        },
      },
      edit: {
        featureGroup: drawnItems,
        remove: true,
      },
    });
    
    map.addControl(drawControl);
    
    // Event handler for when a rectangle is drawn
    map.on(L.Draw.Event.CREATED, (e) => {
      if (e.layerType === 'rectangle') {
        const layer = e.layer;
        drawnItems.clearLayers();
        drawnItems.addLayer(layer);
        
        const bounds = layer.getBounds();
        
        // Ensure coordinates are properly ordered and within valid ranges
        let north = bounds.getNorth();
        let south = bounds.getSouth();
        let east = bounds.getEast();
        let west = bounds.getWest();
        
        // Normalize longitude values to be within -180 to 180
        east = ((east + 180) % 360) - 180;
        west = ((west + 180) % 360) - 180;
        
        // Ensure coordinates are within valid ranges
        north = Math.min(Math.max(north, -90), 90);
        south = Math.min(Math.max(south, -90), 90);
        
        // Make sure there's a small difference if the coordinates are very close
        const minDifference = 0.0000001;
        
        // If north and south are too close or equal, adjust them slightly
        const adjustedNorth = north === south ? Math.min(north + minDifference, 90) : north;
        const adjustedSouth = north === south ? Math.max(south - minDifference, -90) : south;
        
        // Similarly for east and west
        const adjustedEast = east === west ? Math.min(east + minDifference, 180) : east;
        const adjustedWest = east === west ? Math.max(west - minDifference, -180) : west;
        
        onRectangleDrawn({
          north: adjustedNorth,
          south: adjustedSouth,
          east: adjustedEast,
          west: adjustedWest,
        });
      }
    });
    
    // Event handler for when a rectangle is deleted
    map.on(L.Draw.Event.DELETED, () => {
      drawnItems.clearLayers();
      setCoordinates({
        north: '',
        south: '',
        east: '',
        west: '',
      });
    });
    
    return () => {
      map.removeControl(drawControl);
      map.off(L.Draw.Event.CREATED);
      map.off(L.Draw.Event.DELETED);
    };
  }, [map, onRectangleDrawn]);
  
  return null;
};

// Helper component to add NDVI tile layer
const NDVITileLayer = ({ url, attribution }) => {
  if (!url) return null;
  
  return (
    <TileLayer
      url={url}
      attribution={attribution || 'Google Earth Engine'}
    />
  );
};

const NDVIAnalyzer = () => {
  // State for coordinates
  const [coordinates, setCoordinates] = useState({
    north: '',
    south: '',
    east: '',
    west: '',
  });
  
  // State for years
  const [years, setYears] = useState({
    startYear: new Date().getFullYear() - 5, // Default to 5 years ago
    endYear: new Date().getFullYear(), // Default to current year
  });
  
  // State for results
  const [results, setResults] = useState(null);
  
  // State for loading and error
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);
  
  // Handle rectangle drawn on map
  const handleRectangleDrawn = (rectCoords) => {
    // Process the coordinates to ensure North > South and East > West
    const north = Math.max(rectCoords.north, rectCoords.south);
    const south = Math.min(rectCoords.north, rectCoords.south);
    const east = Math.max(rectCoords.east, rectCoords.west);
    const west = Math.min(rectCoords.east, rectCoords.west);
    
    setCoordinates({
      north,
      south,
      east,
      west
    });
  };
  
  // Handle coordinate input changes
  const handleCoordinateChange = (e) => {
    const { name, value } = e.target;
    
    // Convert value to number for validation
    const numValue = parseFloat(value);
    
    // Validate coordinates based on their type
    let validatedValue = value;
    if (!isNaN(numValue)) {
      if (name === 'north' || name === 'south') {
        // Latitude must be between -90 and 90
        validatedValue = Math.min(Math.max(numValue, -90), 90);
      } else if (name === 'east' || name === 'west') {
        // Longitude must be between -180 and 180
        validatedValue = ((numValue + 180) % 360) - 180;
      }
    }
    
    // Update the coordinates state
    setCoordinates((prev) => {
      const newCoordinates = {
        ...prev,
        [name]: validatedValue.toString(),
      };
      
      // Clear any previous errors when coordinates are changed
      setError(null);
      
      return newCoordinates;
    });
  };
  
  // Handle year input changes
  const handleYearChange = (e) => {
    const { name, value } = e.target;
    setYears((prev) => ({
      ...prev,
      [name]: value,
    }));
  };
  
  // Handle form submission
  const handleSubmit = async (e) => {
    e.preventDefault();
    
    // Validate form
    if (!coordinates.north || !coordinates.south || !coordinates.east || !coordinates.west) {
      setError('Please select an area on the map or enter coordinates manually');
      return;
    }
    
    // Validate that coordinates are numeric
    for (const [key, value] of Object.entries(coordinates)) {
      if (isNaN(parseFloat(value))) {
        setError(`Invalid ${key} coordinate: must be a number`);
        return;
      }
    }
    
    // Ensure coordinates are in proper range
    if (parseFloat(coordinates.north) <= parseFloat(coordinates.south)) {
      setError('North latitude must be greater than South latitude');
      return;
    }
    
    if (parseFloat(coordinates.east) <= parseFloat(coordinates.west)) {
      setError('East longitude must be greater than West longitude');
      return;
    }
    
    setIsLoading(true);
    setError(null);
    
    try {
      const result = await analyzeArea(
        {
          north: parseFloat(coordinates.north),
          south: parseFloat(coordinates.south),
          east: parseFloat(coordinates.east),
          west: parseFloat(coordinates.west)
        },
        parseInt(years.startYear),
        parseInt(years.endYear)
      );
      
      setResults(result);
    } catch (err) {
      setError(err.message || 'Failed to analyze NDVI');
    } finally {
      setIsLoading(false);
    }
  };
  
  // Format NDVI value as text
  const formatNDVIValue = (value) => {
    if (value === undefined || value === null) return 'N/A';
    return value.toFixed(3);
  };
  
  // Get color class for change category
  const getChangeColorClass = (category) => {
    if (!category) return 'text-white';
    
    if (category.includes('Significant decrease')) return 'text-red-500';
    if (category.includes('Moderate decrease')) return 'text-orange-500';
    if (category.includes('Slight decrease')) return 'text-yellow-500';
    if (category.includes('No significant change')) return 'text-white';
    if (category.includes('Slight increase')) return 'text-green-300';
    if (category.includes('Moderate increase')) return 'text-green-400';
    if (category.includes('Significant increase')) return 'text-[#C4FB6D]';
    
    return 'text-white';
  };
  
  return (
    <>
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-white mb-2">NDVI Analyzer</h1>
        <p className="text-[#94A3B8]">
          Analyze vegetation health and changes over time using satellite imagery
        </p>
      </div>
      
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Input Form */}
        <motion.div
          className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
        >
          <form onSubmit={handleSubmit}>
            <div className="mb-6">
              <h2 className="text-xl font-bold text-white mb-4">
                Select Area
              </h2>
              
              {/* Map for drawing area */}
              <div className="h-[300px] mb-4 rounded-xl overflow-hidden">
                <MapContainer
                  center={[20, 0]}
                  zoom={2}
                  style={{ height: '100%', width: '100%' }}
                >
                  <TileLayer
                    url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                    attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                  />
                  
                  <DrawControls onRectangleDrawn={handleRectangleDrawn} />
                  
                  {coordinates.north && coordinates.south && coordinates.east && coordinates.west && (
                    <Rectangle
                      bounds={[
                        [coordinates.south, coordinates.west],
                        [coordinates.north, coordinates.east]
                      ]}
                      pathOptions={{ 
                        color: '#76EAD7', 
                        weight: 2,
                        opacity: 1,
                        fillOpacity: 0.3,
                        fillColor: '#76EAD7'
                      }}
                    />
                  )}
                </MapContainer>
              </div>
              
              <p className="text-sm text-[#94A3B8] mb-4">
                <strong>Click the rectangle tool</strong> in the top left of the map to draw a rectangle, or enter coordinates manually below.
              </p>
              
              {/* Coordinates inputs */}
              <div className="grid grid-cols-2 gap-4 mb-6">
                <div>
                  <label
                    htmlFor="north"
                    className="block mb-2 text-sm font-medium text-[#94A3B8]"
                  >
                    North Latitude
                  </label>
                  <input
                    type="number"
                    id="north"
                    name="north"
                    value={coordinates.north}
                    onChange={handleCoordinateChange}
                    step="any"
                    min="-90"
                    max="90"
                    placeholder="e.g., 45.123"
                    className="block w-full px-4 py-3 rounded-xl bg-[#0F172A] text-white border border-[#76EAD7]/20 
                              hover:border-[#76EAD7]/40 focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/20"
                  />
                </div>
                <div>
                  <label
                    htmlFor="south"
                    className="block mb-2 text-sm font-medium text-[#94A3B8]"
                  >
                    South Latitude
                  </label>
                  <input
                    type="number"
                    id="south"
                    name="south"
                    value={coordinates.south}
                    onChange={handleCoordinateChange}
                    step="any"
                    min="-90"
                    max="90"
                    placeholder="e.g., 42.987"
                    className="block w-full px-4 py-3 rounded-xl bg-[#0F172A] text-white border border-[#76EAD7]/20 
                              hover:border-[#76EAD7]/40 focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/20"
                  />
                </div>
                <div>
                  <label
                    htmlFor="east"
                    className="block mb-2 text-sm font-medium text-[#94A3B8]"
                  >
                    East Longitude
                  </label>
                  <input
                    type="number"
                    id="east"
                    name="east"
                    value={coordinates.east}
                    onChange={handleCoordinateChange}
                    step="any"
                    min="-180"
                    max="180"
                    placeholder="e.g., 78.456"
                    className="block w-full px-4 py-3 rounded-xl bg-[#0F172A] text-white border border-[#76EAD7]/20 
                              hover:border-[#76EAD7]/40 focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/20"
                  />
                </div>
                <div>
                  <label
                    htmlFor="west"
                    className="block mb-2 text-sm font-medium text-[#94A3B8]"
                  >
                    West Longitude
                  </label>
                  <input
                    type="number"
                    id="west"
                    name="west"
                    value={coordinates.west}
                    onChange={handleCoordinateChange}
                    step="any"
                    min="-180"
                    max="180"
                    placeholder="e.g., 75.789"
                    className="block w-full px-4 py-3 rounded-xl bg-[#0F172A] text-white border border-[#76EAD7]/20 
                              hover:border-[#76EAD7]/40 focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/20"
                  />
                </div>
              </div>
            </div>
            
            <div className="mb-6">
              <h2 className="text-xl font-bold text-white mb-4">
                Time Period
              </h2>
              
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label
                    htmlFor="startYear"
                    className="block mb-2 text-sm font-medium text-[#94A3B8]"
                  >
                    Start Year
                  </label>
                  <input
                    type="number"
                    id="startYear"
                    name="startYear"
                    value={years.startYear}
                    onChange={handleYearChange}
                    min="1990"
                    max={new Date().getFullYear()}
                    className="block w-full px-4 py-3 rounded-xl bg-[#0F172A] text-white border border-[#76EAD7]/20 
                              hover:border-[#76EAD7]/40 focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/20"
                  />
                </div>
                <div>
                  <label
                    htmlFor="endYear"
                    className="block mb-2 text-sm font-medium text-[#94A3B8]"
                  >
                    End Year
                  </label>
                  <input
                    type="number"
                    id="endYear"
                    name="endYear"
                    value={years.endYear}
                    onChange={handleYearChange}
                    min="1990"
                    max={new Date().getFullYear()}
                    className="block w-full px-4 py-3 rounded-xl bg-[#0F172A] text-white border border-[#76EAD7]/20 
                              hover:border-[#76EAD7]/40 focus:outline-none focus:ring-2 focus:ring-[#76EAD7]/20"
                  />
                </div>
              </div>
            </div>
            
            <motion.button
              type="submit"
              className="w-full btn-primary"
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              disabled={isLoading}
            >
              {isLoading ? 'Analyzing...' : 'Analyze Vegetation'}
            </motion.button>
            
            {error && (
              <div className="mt-4 p-4 bg-red-800/30 text-red-200 rounded-xl">
                {error}
              </div>
            )}
          </form>
        </motion.div>
        
        {/* Results Display */}
        <div>
          {results ? (
            <motion.div
              className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-6 border border-[#76EAD7]/10"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: 0.2 }}
            >
              <h2 className="text-xl font-bold text-white mb-4">Analysis Results</h2>
              
              {/* Analysis Summary */}
              <div className="mb-6 p-4 bg-[#0F172A]/90 rounded-xl">
                <div className="grid grid-cols-2 gap-y-4 mb-4">
                  <div>
                    <p className="text-[#94A3B8] text-sm">Start Year NDVI</p>
                    <p className="text-white text-lg font-semibold">
                      {formatNDVIValue(results.startNDVI)}
                    </p>
                  </div>
                  <div>
                    <p className="text-[#94A3B8] text-sm">End Year NDVI</p>
                    <p className="text-white text-lg font-semibold">
                      {formatNDVIValue(results.endNDVI)}
                    </p>
                  </div>
                  <div>
                    <p className="text-[#94A3B8] text-sm">NDVI Change</p>
                    <p className="text-white text-lg font-semibold">
                      {results.ndviChange > 0 ? '+' : ''}
                      {formatNDVIValue(results.ndviChange)}
                    </p>
                  </div>
                  <div>
                    <p className="text-[#94A3B8] text-sm">Change Category</p>
                    <p className={`text-lg font-semibold ${getChangeColorClass(results.changeCategory)}`}>
                      {results.changeCategory}
                    </p>
                  </div>
                </div>
                
                <div className="flex items-center">
                  <div className="flex-1 h-2 rounded-full overflow-hidden bg-[#1E293B]">
                    <div
                      className="h-full bg-gradient-to-r from-[#76EAD7] to-[#C4FB6D]"
                      style={{
                        width: `${Math.min(Math.max((results.endNDVI / 0.8) * 100, 0), 100)}%`,
                      }}
                    ></div>
                  </div>
                </div>
              </div>
              
              {/* Maps Display */}
              <div className="space-y-6">
                {/* Start Year Map */}
                <div>
                  <h3 className="text-lg font-medium text-white mb-2">
                    {results.startYear} NDVI Map
                  </h3>
                  <div className="h-[200px] rounded-xl overflow-hidden">
                    <MapContainer
                      center={[0, 0]}
                      zoom={2}
                      style={{ height: '100%', width: '100%' }}
                      scrollWheelZoom={false}
                    >
                      <TileLayer
                        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                      />
                      <NDVITileLayer url={results.mapUrls?.startNDVI} />
                      <MapBoundsUpdater bounds={results.bounds} />
                    </MapContainer>
                  </div>
                </div>
                
                {/* End Year Map */}
                <div>
                  <h3 className="text-lg font-medium text-white mb-2">
                    {results.endYear} NDVI Map
                  </h3>
                  <div className="h-[200px] rounded-xl overflow-hidden">
                    <MapContainer
                      center={[0, 0]}
                      zoom={2}
                      style={{ height: '100%', width: '100%' }}
                      scrollWheelZoom={false}
                    >
                      <TileLayer
                        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                      />
                      <NDVITileLayer url={results.mapUrls?.endNDVI} />
                      <MapBoundsUpdater bounds={results.bounds} />
                    </MapContainer>
                  </div>
                </div>
                
                {/* Difference Map */}
                <div>
                  <h3 className="text-lg font-medium text-white mb-2">
                    NDVI Change Map ({results.startYear} to {results.endYear})
                  </h3>
                  <div className="h-[200px] rounded-xl overflow-hidden">
                    <MapContainer
                      center={[0, 0]}
                      zoom={2}
                      style={{ height: '100%', width: '100%' }}
                      scrollWheelZoom={false}
                    >
                      <TileLayer
                        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                      />
                      <NDVITileLayer url={results.mapUrls?.ndviDiff} />
                      <MapBoundsUpdater bounds={results.bounds} />
                    </MapContainer>
                  </div>
                </div>
              </div>
              
              {/* Legend */}
              <div className="mt-6 grid grid-cols-2 gap-4">
                <div>
                  <h3 className="text-sm font-medium text-[#94A3B8] mb-2">NDVI Values</h3>
                  <div className="h-2 w-full rounded-full bg-gradient-to-r from-[#d73027] via-[#fee08b] to-[#1a9850]"></div>
                  <div className="flex justify-between mt-1">
                    <span className="text-xs text-[#94A3B8]">0.0</span>
                    <span className="text-xs text-[#94A3B8]">0.4</span>
                    <span className="text-xs text-[#94A3B8]">0.8</span>
                  </div>
                </div>
                <div>
                  <h3 className="text-sm font-medium text-[#94A3B8] mb-2">NDVI Change</h3>
                  <div className="h-2 w-full rounded-full bg-gradient-to-r from-[#d73027] via-[#ffffbf] to-[#1a9850]"></div>
                  <div className="flex justify-between mt-1">
                    <span className="text-xs text-[#94A3B8]">-0.3</span>
                    <span className="text-xs text-[#94A3B8]">0</span>
                    <span className="text-xs text-[#94A3B8]">+0.3</span>
                  </div>
                </div>
              </div>
            </motion.div>
          ) : (
            <motion.div
              className="bg-[#1E293B]/50 backdrop-blur-xl rounded-2xl p-8 border border-[#76EAD7]/10 h-full flex flex-col items-center justify-center text-center"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: 0.2 }}
            >
              <div className="w-20 h-20 mb-6 rounded-full bg-[#76EAD7]/10 flex items-center justify-center">
                <svg
                  className="w-10 h-10 text-[#76EAD7]"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={1.5}
                    d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7"
                  />
                </svg>
              </div>
              <h2 className="text-white text-xl font-bold mb-2">
                Ready to Analyze
              </h2>
              <p className="text-[#94A3B8] max-w-sm">
                Select an area on the map by drawing a rectangle or enter coordinates manually
                to analyze vegetation health and changes.
              </p>
            </motion.div>
          )}
        </div>
      </div>
    </>
  );
};

export default NDVIAnalyzer; 