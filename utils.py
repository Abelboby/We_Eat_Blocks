from PIL import Image
from PIL.ExifTags import TAGS, GPSTAGS
import ee
from datetime import datetime, timedelta

def get_decimal_coordinates(gps_coords):
    degrees = float(gps_coords[0])
    minutes = float(gps_coords[1])
    seconds = float(gps_coords[2])
    
    return degrees + (minutes / 60.0) + (seconds / 3600.0)

def extract_coordinates(image_path):
    try:
        image = Image.open(image_path)
        exif = image._getexif()
        
        if not exif:
            print("No EXIF data found in image")
            return None
            
        gps_info = {}
        
        for tag, value in exif.items():
            tag_name = TAGS.get(tag, tag)
            if tag_name == 'GPSInfo':
                for gps_tag in value:
                    sub_tag = GPSTAGS.get(gps_tag, gps_tag)
                    gps_info[sub_tag] = value[gps_tag]
        
        if not gps_info:
            print("No GPS information found in EXIF data")
            return None
            
        lat = get_decimal_coordinates(gps_info['GPSLatitude'])
        if gps_info['GPSLatitudeRef'] == 'S':
            lat = -lat
            
        lon = get_decimal_coordinates(gps_info['GPSLongitude'])
        if gps_info['GPSLongitudeRef'] == 'W':
            lon = -lon
            
        return {'latitude': lat, 'longitude': lon}
        
    except Exception as e:
        print(f"Error extracting coordinates: {str(e)}")
        return None

def calculate_ndvi(coordinates, start_year=None, end_year=None):
    try:
        # Create rectangle geometry
        area = ee.Geometry.Rectangle([
            coordinates['long1'],
            coordinates['lat2'],
            coordinates['long2'],
            coordinates['lat1']
        ])
        
        # Define visualization parameters for NDVI
        ndvi_vis_params = {
            'min': 0,
            'max': 0.8,
            'palette': [
                '#d73027',  # Red (No vegetation: 0.0 - 0.1)
                '#f46d43',  # Orange-Red (Very sparse: 0.1 - 0.2)
                '#fdae61',  # Light Orange (Sparse: 0.2 - 0.3)
                '#fee08b',  # Yellow (Moderate: 0.3 - 0.4)
                '#d9ef8b',  # Light Green (Good: 0.4 - 0.5)
                '#a6d96a',  # Medium Green (Very good: 0.5 - 0.6)
                '#66bd63',  # Green (Dense: 0.6 - 0.7)
                '#1a9850'   # Dark Green (Very dense: > 0.7)
            ]
        }
        
        # Set date range based on input years or default to current year
        if start_year and end_year:
            start_date = f"{start_year}-01-01"
            end_date = f"{end_year}-12-31"
        else:
            end_date = datetime.now()
            start_date = end_date - timedelta(days=365)
            start_date = start_date.strftime('%Y-%m-%d')
            end_date = end_date.strftime('%Y-%m-%d')
        
        # Load Landsat collection
        l8 = ee.ImageCollection('LANDSAT/LC08/C02/T1_TOA') \
            .filterBounds(area) \
            .filterDate(start_date, end_date) \
            .filter(ee.Filter.lt('CLOUD_COVER', 20))
        
        # Calculate NDVI
        def addNDVI(image):
            ndvi = image.normalizedDifference(['B5', 'B4']).rename('NDVI')
            return image.addBands(ndvi)
        
        withNDVI = l8.map(addNDVI)
        
        # Get NDVI values for start and end periods
        if start_year and end_year:
            start_period = withNDVI.filterDate(start_date, f"{int(start_year)+1}-01-01").select('NDVI').mean()
            end_period = withNDVI.filterDate(f"{int(end_year)-1}-12-31", end_date).select('NDVI').mean()
            
            start_value = start_period.reduceRegion(
                reducer=ee.Reducer.mean(),
                geometry=area,
                scale=30
            ).get('NDVI').getInfo()
            
            end_value = end_period.reduceRegion(
                reducer=ee.Reducer.mean(),
                geometry=area,
                scale=30
            ).get('NDVI').getInfo()
            
            ndvi_change = end_value - start_value
            vegetation_change = "Significant increase" if ndvi_change > 0.2 else \
                              "Moderate increase" if ndvi_change > 0.1 else \
                              "Slight increase" if ndvi_change > 0.05 else \
                              "No significant change" if abs(ndvi_change) <= 0.05 else \
                              "Slight decrease" if ndvi_change > -0.1 else \
                              "Moderate decrease" if ndvi_change > -0.2 else \
                              "Significant decrease"
            
            # Generate map URLs
            start_map_id = start_period.getMapId(ndvi_vis_params)
            end_map_id = end_period.getMapId(ndvi_vis_params)
            
            # Calculate difference image
            diff_image = end_period.subtract(start_period)
            diff_vis_params = {
                'min': -0.3,
                'max': 0.3,
                'palette': [
                    '#d73027',  # Red (Significant decrease)
                    '#f46d43',  # Orange-Red (Moderate decrease)
                    '#fdae61',  # Light Orange (Slight decrease)
                    '#ffffff',  # White (No change)
                    '#a6d96a',  # Light Green (Slight increase)
                    '#66bd63',  # Medium Green (Moderate increase)
                    '#1a9850'   # Dark Green (Significant increase)
                ]
            }
            diff_map_id = diff_image.getMapId(diff_vis_params)
            
            return {
                'start_ndvi': start_value,
                'end_ndvi': end_value,
                'ndvi_change': ndvi_change,
                'vegetation_change': vegetation_change,
                'coordinates': coordinates,
                'time_period': f"{start_year} - {end_year}",
                'start_image_url': start_map_id['tile_fetcher'].url_format,
                'end_image_url': end_map_id['tile_fetcher'].url_format,
                'diff_image_url': diff_map_id['tile_fetcher'].url_format,
                'bounds': {
                    'north': coordinates['lat1'],
                    'south': coordinates['lat2'],
                    'east': coordinates['long2'],
                    'west': coordinates['long1']
                }
            }
        else:
            # Single period analysis
            recent_ndvi = withNDVI.select('NDVI').mean()
            
            # Generate map URL
            map_id = recent_ndvi.getMapId(ndvi_vis_params)
            
            return {
                'ndvi_mean': ndvi_mean,
                'ndvi_stddev': ndvi_stddev,
                'vegetation_status': vegetation_status,
                'coordinates': coordinates,
                'area_hectares': area.area().getInfo() / 10000,
                'ndvi_image_url': map_id['tile_fetcher'].url_format,
                'bounds': {
                    'north': coordinates['lat1'],
                    'south': coordinates['lat2'],
                    'east': coordinates['long2'],
                    'west': coordinates['long1']
                }
            }
        
    except Exception as e:
        raise Exception(f"Error calculating NDVI: {str(e)}") 