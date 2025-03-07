# API Testing Scripts for Vegetation Analysis Application

These scripts allow you to test the API endpoints of your [Vegetation Analysis Application](https://vegetation-analysis.onrender.com) deployed on Render.

## Requirements

Install the required packages:
```
pip install requests
```

## 1. Testing the Analyze API (`test.py`)

This script tests the `/api/analyze` endpoint that calculates NDVI (Normalized Difference Vegetation Index) for a specified geographic area and time period.

### Basic Usage
```
python test.py
```
This will run a test with default coordinates (an agricultural region in Kansas) for the period 2015-2022, which is known to have good Landsat 8 satellite coverage.

### Custom Coordinates and Time Period
```
python test.py <north> <south> <east> <west> [start_year] [end_year] [scale]
```

Example:
```
python test.py 39.55 39.45 -96.45 -96.55 2015 2022 30
```
This will analyze an agricultural region in Kansas from 2015 to 2022 at 30m resolution.

### Scale Parameter
The `scale` parameter (default: 30) defines the resolution in meters. Higher values mean lower resolution but fewer pixels to process:
- 30: Standard Landsat resolution (default)
- 60: Lower resolution, ~4x fewer pixels to process
- 100: Much lower resolution, ~11x fewer pixels to process

Example with higher scale (lower resolution):
```
python test.py 39.55 39.45 -96.45 -96.55 2015 2022 100
```

### Run Multiple Tests
```
python test.py --run-all
```
This will run tests for three predefined regions with known good satellite coverage:
1. Agricultural region in Kansas, USA
2. Rainforest/agricultural boundary in Brazil
3. Agricultural region in Australia

## Best Practices for Successful Requests

### 1. Choose Appropriate Region Sizes
- Keep regions small (typically less than 0.1° x 0.1° for best results)
- The API has a maximum pixel limit of 10 million pixels
- The script will estimate pixel count and warn you if it's too large

### 2. Select Time Periods with Good Coverage
- 2015-2022 generally has the best Landsat 8 coverage
- Avoid very recent data (current year may have incomplete coverage)
- Using a wider time range increases chances of finding cloud-free imagery

### 3. Choose Regions with Known Good Coverage
- Agricultural regions typically have good coverage
- Heavily cloudy regions (e.g., tropical rainforests) may have limited imagery
- Extreme latitudes may have seasonal coverage gaps

## Common Errors and Solutions

### "Too many pixels in the region"
- Use a smaller geographic area (reduce the coordinate range)
- Increase the scale parameter (e.g., from 30 to 100)

### "No satellite imagery available"
- Try a different time period (2015-2022 works best)
- Select a different geographic region
- Slightly expand the area to increase chances of finding imagery

## 2. Testing the Upload API (`test_upload.py`)

This script tests the `/api/upload` endpoint that processes uploaded satellite imagery.

### Usage
```
python test_upload.py <path_to_image_file>
```

Example:
```
python test_upload.py test_image.jpg
```

The upload script will:
1. Validate the file type (supported types: jpg, jpeg, png, tif, tiff)
2. Upload the file to the API
3. Display the API response
4. If coordinates are extracted from the image, provide a command to use those coordinates with the analyze API

## Working with Both Scripts

A typical workflow might be:
1. Upload a satellite image using `test_upload.py`
2. Use the extracted coordinates with `test.py` to analyze vegetation in that area

## Troubleshooting

If you encounter errors:
1. Check your internet connection
2. Verify that the API server is running
3. Examine the response status code and error message
4. Ensure input data is valid (coordinates, file types, etc.)

## Notes

- The API might take several seconds to respond, especially for the first request after server idle time
- The analyze endpoint processes Landsat 8 satellite imagery, which might not be available for all regions or time periods
- For large areas or long time periods, the request might time out 