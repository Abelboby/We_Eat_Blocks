let startMap, endMap, diffMap, drawMap;
let currentRectangle = null;

function initializeMaps(bounds) {
    const mapOptions = {
        zoomControl: true,
        scrollWheelZoom: false
    };
    
    if (startMap) startMap.remove();
    if (endMap) endMap.remove();
    if (diffMap) diffMap.remove();
    
    startMap = L.map('start-map', mapOptions);
    endMap = L.map('end-map', mapOptions);
    diffMap = L.map('diff-map', mapOptions);
    
    const mapBounds = L.latLngBounds(
        [bounds.south, bounds.west],
        [bounds.north, bounds.east]
    );
    
    startMap.fitBounds(mapBounds);
    endMap.fitBounds(mapBounds);
    diffMap.fitBounds(mapBounds);
    
    return [startMap, endMap, diffMap];
}

function addTileLayer(map, url) {
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors'
    }).addTo(map);
    
    L.tileLayer(url, {
        opacity: 0.7
    }).addTo(map);
}

async function uploadImage() {
    const fileInput = document.getElementById('imageInput');
    const loading = document.getElementById('loading');
    const results = document.getElementById('results');
    const resultsContent = document.getElementById('resultsContent');
    const error = document.getElementById('error');
    const latitude1 = document.getElementById('latitude1').value;
    const longitude1 = document.getElementById('longitude1').value;
    const latDirection1 = document.getElementById('latDirection1').value;
    const longDirection1 = document.getElementById('longDirection1').value;
    const latitude2 = document.getElementById('latitude2').value;
    const longitude2 = document.getElementById('longitude2').value;
    const latDirection2 = document.getElementById('latDirection2').value;
    const longDirection2 = document.getElementById('longDirection2').value;
    const startYear = document.getElementById('startYear').value;
    const endYear = document.getElementById('endYear').value;
    
    if (!fileInput.files.length) {
        showError('Please select an image to analyze');
        return;
    }
    
    // Validate coordinate inputs if provided
    if (latitude1 || longitude1 || latitude2 || longitude2) {
        if (!latitude1 || !longitude1 || !latitude2 || !longitude2) {
            showError('Please enter both sets of coordinates');
            return;
        }
        if (isNaN(latitude1) || isNaN(longitude1) || isNaN(latitude2) || isNaN(longitude2)) {
            showError('Please enter valid numbers for coordinates');
            return;
        }
        if (parseFloat(latitude1) < 0 || parseFloat(latitude1) > 90 || 
            parseFloat(latitude2) < 0 || parseFloat(latitude2) > 90) {
            showError('Latitude must be between 0 and 90 degrees');
            return;
        }
        if (parseFloat(longitude1) < 0 || parseFloat(longitude1) > 180 ||
            parseFloat(longitude2) < 0 || parseFloat(longitude2) > 180) {
            showError('Longitude must be between 0 and 180 degrees');
            return;
        }
    }
    
    // Validate year inputs
    if (startYear || endYear) {
        if (!startYear || !endYear) {
            showError('Please enter both start and end years');
            return;
        }
        const currentYear = new Date().getFullYear();
        if (startYear < 1990 || endYear > currentYear) {
            showError(`Years must be between 1990 and ${currentYear}`);
            return;
        }
        if (parseInt(startYear) >= parseInt(endYear)) {
            showError('End year must be greater than start year');
            return;
        }
    }
    
    const formData = new FormData();
    formData.append('image', fileInput.files[0]);
    if (latitude1 && longitude1 && latitude2 && longitude2) {
        // Convert to decimal degrees with direction
        const lat1 = parseFloat(latitude1) * (latDirection1 === 'S' ? -1 : 1);
        const long1 = parseFloat(longitude1) * (longDirection1 === 'W' ? -1 : 1);
        const lat2 = parseFloat(latitude2) * (latDirection2 === 'S' ? -1 : 1);
        const long2 = parseFloat(longitude2) * (longDirection2 === 'W' ? -1 : 1);
        formData.append('latitude1', lat1);
        formData.append('longitude1', long1);
        formData.append('latitude2', lat2);
        formData.append('longitude2', long2);
    }
    if (startYear && endYear) {
        formData.append('startYear', startYear);
        formData.append('endYear', endYear);
    }
    
    try {
        loading.classList.remove('hidden');
        results.classList.add('hidden');
        error.classList.add('hidden');
        
        const response = await fetch('/upload', {
            method: 'POST',
            body: formData
        });
        
        const data = await response.json();
        
        if (!response.ok) {
            throw new Error(data.error || 'Failed to analyze image');
        }
        
        // Show maps container
        const mapsContainer = document.getElementById('maps-container');
        mapsContainer.classList.remove('hidden');
        
        // Initialize maps
        const [startMap, endMap, diffMap] = initializeMaps(data.bounds);
        
        if (data.time_period) {
            // Add tile layers for temporal analysis
            addTileLayer(startMap, data.start_image_url);
            addTileLayer(endMap, data.end_image_url);
            addTileLayer(diffMap, data.diff_image_url);
            
            // Update map labels
            document.getElementById('start-year-label').textContent = 
                `Initial NDVI (${data.time_period.split(' - ')[0]})`;
            document.getElementById('end-year-label').textContent = 
                `Final NDVI (${data.time_period.split(' - ')[1]})`;
        } else {
            // Add tile layer for single period analysis
            addTileLayer(startMap, data.ndvi_image_url);
            mapsContainer.querySelector('.maps-grid').style.gridTemplateColumns = '1fr';
            document.getElementById('end-map').parentElement.style.display = 'none';
            document.getElementById('diff-map').parentElement.style.display = 'none';
        }
        
        resultsContent.innerHTML = `
            ${data.time_period ? `
                <p><strong>Time Period:</strong> ${data.time_period}</p>
                <p><strong>Initial NDVI (${data.time_period.split(' - ')[0]}):</strong> ${data.start_ndvi.toFixed(3)}</p>
                <p><strong>Final NDVI (${data.time_period.split(' - ')[1]}):</strong> ${data.end_ndvi.toFixed(3)}</p>
                <p><strong>NDVI Change:</strong> ${data.ndvi_change > 0 ? '+' : ''}${data.ndvi_change.toFixed(3)}</p>
                <p><strong>Vegetation Change:</strong> ${data.vegetation_change}</p>
            ` : `
                <p><strong>Mean NDVI Value:</strong> ${data.ndvi_mean.toFixed(3)}</p>
                <p><strong>NDVI Standard Deviation:</strong> ${data.ndvi_stddev.toFixed(3)}</p>
                <p><strong>Vegetation Status:</strong> ${data.vegetation_status}</p>
                <p><strong>Area:</strong> ${data.area_hectares.toFixed(2)} hectares</p>
            `}
            <p><strong>Area Coordinates:</strong></p>
            <p>Top-Left: ${formatCoordinate(data.coordinates.lat1, 'lat')}°, ${formatCoordinate(data.coordinates.long1, 'long')}°</p>
            <p>Bottom-Right: ${formatCoordinate(data.coordinates.lat2, 'lat')}°, ${formatCoordinate(data.coordinates.long2, 'long')}°</p>
        `;
        
        results.classList.remove('hidden');
    } catch (err) {
        showError(err.message);
    } finally {
        loading.classList.add('hidden');
    }
}

function showError(message) {
    const error = document.getElementById('error');
    error.textContent = message;
    error.classList.remove('hidden');
}

function formatCoordinate(decimal, type) {
    const absolute = Math.abs(decimal);
    if (type === 'lat') {
        return `${absolute.toFixed(4)}° ${decimal >= 0 ? 'N' : 'S'}`;
    } else {
        return `${absolute.toFixed(4)}° ${decimal >= 0 ? 'E' : 'W'}`;
    }
}

function analyzeArea() {
    uploadImage();
}

function initializeDrawMap() {
    if (drawMap) drawMap.remove();
    
    drawMap = L.map('draw-map', {
        center: [0, 0],
        zoom: 2
    });
    
    // Add OpenStreetMap tile layer
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors'
    }).addTo(drawMap);
    
    // Initialize the rectangle draw control
    const drawControl = new L.Draw.Rectangle(drawMap);
    
    // Clear existing rectangle when starting to draw
    drawMap.on(L.Draw.Event.DRAWSTART, function (e) {
        if (currentRectangle) {
            drawMap.removeLayer(currentRectangle);
        }
    });
    
    // Handle the drawn rectangle
    drawMap.on(L.Draw.Event.CREATED, function (e) {
        if (currentRectangle) {
            drawMap.removeLayer(currentRectangle);
        }
        
        currentRectangle = e.layer;
        drawMap.addLayer(currentRectangle);
        
        // Get the coordinates of the rectangle
        const bounds = currentRectangle.getBounds();
        const northEast = bounds.getNorthEast();
        const southWest = bounds.getSouthWest();
        
        // Update the coordinate inputs
        document.getElementById('latitude1').value = Math.abs(northEast.lat);
        document.getElementById('latDirection1').value = northEast.lat >= 0 ? 'N' : 'S';
        document.getElementById('longitude1').value = Math.abs(southWest.lng);
        document.getElementById('longDirection1').value = southWest.lng >= 0 ? 'E' : 'W';
        
        document.getElementById('latitude2').value = Math.abs(southWest.lat);
        document.getElementById('latDirection2').value = southWest.lat >= 0 ? 'N' : 'S';
        document.getElementById('longitude2').value = Math.abs(northEast.lng);
        document.getElementById('longDirection2').value = northEast.lng >= 0 ? 'E' : 'W';
    });
    
    // Add draw button
    const drawButton = L.Control.extend({
        options: {
            position: 'topleft'
        },
        onAdd: function (map) {
            const container = L.DomUtil.create('div', 'leaflet-bar leaflet-control');
            container.innerHTML = '<a href="#" title="Draw Rectangle" style="display: flex; align-items: center; justify-content: center; width: 30px; height: 30px; background: white; text-decoration: none; color: black;">⬚</a>';
            
            container.onclick = function() {
                drawControl.enable();
                return false;
            };
            
            return container;
        }
    });
    
    drawMap.addControl(new drawButton());
}

// Initialize the draw map when the page loads
document.addEventListener('DOMContentLoaded', function() {
    initializeDrawMap();
}); 