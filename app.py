from flask import Flask, request, render_template, jsonify, send_file
from werkzeug.utils import secure_filename
import os
from utils import extract_coordinates, calculate_ndvi
import ee
import json
from flask_cors import CORS
import tempfile
from datetime import datetime

app = Flask(__name__)
# Enable CORS for all routes with proper configuration
CORS(app, resources={r"/*": {"origins": "*"}})

app.config['UPLOAD_FOLDER'] = 'uploads'
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16MB max file size

# Ensure upload folder exists
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

# Initialize Earth Engine with service account
SERVICE_ACCOUNT_FILE = os.environ.get('GEE_SERVICE_ACCOUNT_FILE', 'serviceAccount.json')

try:
    # Initialize Earth Engine with service account credentials
    credentials = ee.ServiceAccountCredentials(None, SERVICE_ACCOUNT_FILE)
    ee.Initialize(credentials)
    print("Earth Engine initialized successfully with service account.")
except Exception as e:
    print(f"Error initializing Earth Engine: {e}")
    # Fallback to simple initialization if service account fails (for development)
    try:
        ee.Initialize(project='ee-ajith221007')
        print("Earth Engine initialized with project ID fallback.")
    except Exception as e:
        print(f"Fallback initialization also failed: {e}")

ALLOWED_EXTENSIONS = {'jpg', 'jpeg', 'png', 'tif', 'tiff'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def calculate_ndvi(coordinates, start_year=None, end_year=None):
    try:
        # Set default years if not provided
        current_year = datetime.now().year
        if not start_year:
            start_year = current_year - 5  # Default to 5 years ago
        if not end_year:
            end_year = current_year
            
        # Convert to integers
        start_year = int(start_year)
        end_year = int(end_year)
        
        # Ensure coordinates are floats
        for key in coordinates:
            if coordinates[key] is not None:
                coordinates[key] = float(coordinates[key])
            else:
                raise ValueError(f"Missing required coordinate: {key}")
        
        # Define the area of interest
        aoi = ee.Geometry.Rectangle([
            coordinates['west'], 
            coordinates['south'], 
            coordinates['east'], 
            coordinates['north']
        ])
        
        # Define the time periods
        start_date1 = f"{start_year}-01-01"
        end_date1 = f"{start_year}-12-31"
        
        start_date2 = f"{end_year}-01-01"
        end_date2 = f"{end_year}-12-31"
        
        # Get Landsat 8 collection
        l8_collection1 = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2') \
            .filterBounds(aoi) \
            .filterDate(start_date1, end_date1) \
            .filter(ee.Filter.lt('CLOUD_COVER', 20))
            
        l8_collection2 = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2') \
            .filterBounds(aoi) \
            .filterDate(start_date2, end_date2) \
            .filter(ee.Filter.lt('CLOUD_COVER', 20))
        
        # Check if collections are empty
        collection1_size = l8_collection1.size().getInfo()
        collection2_size = l8_collection2.size().getInfo()
        
        if collection1_size == 0 or collection2_size == 0:
            raise ValueError("No satellite imagery available for the selected area and time period. Try expanding the area or selecting a different time period.")
        
        # Function to add NDVI band
        def addNDVI(image):
            ndvi = image.normalizedDifference(['SR_B5', 'SR_B4']).rename('NDVI')
            return image.addBands(ndvi)
        
        # Add NDVI band to the collections
        ndvi_collection1 = l8_collection1.map(addNDVI)
        ndvi_collection2 = l8_collection2.map(addNDVI)
        
        # Get median NDVI images
        ndvi_median1 = ndvi_collection1.select('NDVI').median()
        ndvi_median2 = ndvi_collection2.select('NDVI').median()
        
        # Calculate difference
        ndvi_diff = ndvi_median2.subtract(ndvi_median1)
        
        # Get NDVI stats for the region
        ndvi_stats1 = ndvi_median1.reduceRegion(
            reducer=ee.Reducer.mean(),
            geometry=aoi,
            scale=30
        ).getInfo()
        
        ndvi_stats2 = ndvi_median2.reduceRegion(
            reducer=ee.Reducer.mean(),
            geometry=aoi,
            scale=30
        ).getInfo()
        
        ndvi_diff_stats = ndvi_diff.reduceRegion(
            reducer=ee.Reducer.mean(),
            geometry=aoi,
            scale=30
        ).getInfo()
        
        # Get values safely with defaults if None
        start_ndvi = ndvi_stats1.get('NDVI', 0)
        end_ndvi = ndvi_stats2.get('NDVI', 0)
        diff_value = ndvi_diff_stats.get('NDVI', 0)
        
        # Guard against None values
        if start_ndvi is None:
            start_ndvi = 0
        if end_ndvi is None:
            end_ndvi = 0
        if diff_value is None:
            diff_value = 0
        
        # Get URLs for the NDVI map visualizations
        vis_params_ndvi = {'min': 0, 'max': 0.8, 'palette': [
            '#d73027', '#f46d43', '#fdae61', '#fee08b',
            '#d9ef8b', '#a6d96a', '#66bd63', '#1a9850'
        ]}
        
        vis_params_diff = {
            'min': -0.3, 
            'max': 0.3, 
            'palette': [
                '#d73027', '#f46d43', '#fdae61', '#fee08b',
                '#ffffbf',
                '#d9ef8b', '#a6d96a', '#66bd63', '#1a9850'
            ]
        }
        
        map_id1 = ndvi_median1.getMapId(vis_params_ndvi)
        map_id2 = ndvi_median2.getMapId(vis_params_ndvi)
        map_id_diff = ndvi_diff.getMapId(vis_params_diff)
        
        # Determine vegetation change category
        if diff_value < -0.20:
            change_category = "Significant decrease"
        elif diff_value < -0.10:
            change_category = "Moderate decrease"
        elif diff_value < -0.03:
            change_category = "Slight decrease"
        elif diff_value < 0.03:
            change_category = "No significant change"
        elif diff_value < 0.10:
            change_category = "Slight increase"
        elif diff_value < 0.20:
            change_category = "Moderate increase"
        else:
            change_category = "Significant increase"
        
        # Return results as a JSON-serializable dictionary
        return {
            'startYear': start_year,
            'endYear': end_year,
            'startNDVI': start_ndvi,
            'endNDVI': end_ndvi,
            'ndviChange': diff_value,
            'changeCategory': change_category,
            'mapUrls': {
                'startNDVI': f"https://earthengine.googleapis.com/v1alpha/{map_id1['mapid']}/tiles/{{z}}/{{x}}/{{y}}",
                'endNDVI': f"https://earthengine.googleapis.com/v1alpha/{map_id2['mapid']}/tiles/{{z}}/{{x}}/{{y}}",
                'ndviDiff': f"https://earthengine.googleapis.com/v1alpha/{map_id_diff['mapid']}/tiles/{{z}}/{{x}}/{{y}}"
            },
            'bounds': coordinates
        }
        
    except Exception as e:
        print(f"Error calculating NDVI: {e}")
        raise ValueError(f"Error analyzing vegetation: {str(e)}")

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/analyze', methods=['POST', 'OPTIONS'])
def analyze_api():
    # Handle preflight OPTIONS request
    if request.method == 'OPTIONS':
        response = app.make_default_options_response()
        response.headers.add('Access-Control-Allow-Methods', 'POST')
        response.headers.add('Access-Control-Allow-Headers', 'Content-Type')
        return response
        
    try:
        data = request.json
        
        # Extract coordinates from the request
        coordinates = {
            'north': data.get('north'),
            'south': data.get('south'),
            'east': data.get('east'),
            'west': data.get('west')
        }
        
        # Extract years from the request
        start_year = data.get('startYear')
        end_year = data.get('endYear')
        
        # Validate coordinates
        if not all(coordinates.values()):
            return jsonify({'error': 'Invalid coordinates provided'}), 400
            
        # Calculate NDVI
        result = calculate_ndvi(coordinates, start_year, end_year)
        
        return jsonify(result)
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/upload', methods=['POST', 'OPTIONS'])
def upload_file_api():
    # Handle preflight OPTIONS request
    if request.method == 'OPTIONS':
        response = app.make_default_options_response()
        response.headers.add('Access-Control-Allow-Methods', 'POST')
        response.headers.add('Access-Control-Allow-Headers', 'Content-Type')
        return response
        
    try:
        # Check if file is in the request
        if 'file' not in request.files:
            return jsonify({'error': 'No file part'}), 400
        
        file = request.files['file']
        
        # If user doesn't select file, browser might send empty file
        if file.filename == '':
            return jsonify({'error': 'No selected file'}), 400
            
        # Check if file is valid
        if file and allowed_file(file.filename):
            # Create a temporary file to save the uploaded image
            with tempfile.NamedTemporaryFile(delete=False, suffix=os.path.splitext(file.filename)[1]) as temp:
                file.save(temp.name)
                
                # Extract coordinates from the image
                coordinates = extract_coordinates(temp.name)
                
                # Remove the temporary file
                os.unlink(temp.name)
                
                if coordinates:
                    return jsonify({
                        'success': True,
                        'coordinates': coordinates
                    })
                else:
                    return jsonify({'error': 'No GPS data found in image'}), 400
        else:
            return jsonify({'error': 'Invalid file format'}), 400
            
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)