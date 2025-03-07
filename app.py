from flask import Flask, request, render_template, jsonify
from werkzeug.utils import secure_filename
import os
from utils import extract_coordinates, calculate_ndvi
import ee

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'uploads'
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16MB max file size

# Ensure upload folder exists
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

# Initialize Earth Engine
# Replace 'your-project-id' with your actual Google Cloud Project ID
ee.Initialize(project='ee-ajith221007')

ALLOWED_EXTENSIONS = {'jpg', 'jpeg', 'png', 'tif', 'tiff'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'image' not in request.files:
        return jsonify({'error': 'No file uploaded'}), 400
    
    file = request.files['image']
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400
    
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)
        
        try:
            # Check for manual coordinates first
            if ('latitude1' in request.form and 'longitude1' in request.form and
                'latitude2' in request.form and 'longitude2' in request.form):
                coordinates = {
                    'lat1': float(request.form['latitude1']),
                    'long1': float(request.form['longitude1']),
                    'lat2': float(request.form['latitude2']),
                    'long2': float(request.form['longitude2'])
                }
            else:
                # Extract coordinates from image
                coordinates = extract_coordinates(filepath)

            if not coordinates:
                return jsonify({'error': 'No coordinates found in image. Please enter coordinates manually.'}), 400
            
            # Get years from request if provided
            start_year = request.form.get('startYear')
            end_year = request.form.get('endYear')
            
            # Calculate NDVI using Earth Engine
            ndvi_results = calculate_ndvi(coordinates, start_year, end_year)
            
            # Clean up uploaded file
            os.remove(filepath)
            
            return jsonify(ndvi_results)
            
        except Exception as e:
            if os.path.exists(filepath):
                os.remove(filepath)
            return jsonify({'error': str(e)}), 500
    
    return jsonify({'error': 'Invalid file type'}), 400

if __name__ == '__main__':
    app.run(debug=True) 