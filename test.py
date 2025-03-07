import requests
import json
import time
from datetime import datetime
import sys

# API endpoint
BASE_URL = "https://vegetation-analysis.onrender.com"
ANALYZE_API = f"{BASE_URL}/api/analyze"

def test_analyze_api(coordinates, start_year=None, end_year=None, scale=30):
    """
    Test the /api/analyze endpoint with the provided coordinates and time period.
    
    Parameters:
    - coordinates: Dictionary with 'north', 'south', 'east', 'west' values
    - start_year: Starting year for analysis (optional)
    - end_year: Ending year for analysis (optional)
    - scale: Resolution in meters (higher values = lower resolution, fewer pixels)
    
    Returns:
    - Response from the API
    """
    # Set default years if not provided
    current_year = datetime.now().year
    if not start_year:
        start_year = 2015  # Default to 2015 for better Landsat 8 coverage
    if not end_year:
        end_year = 2022  # Default to 2022 to ensure good data availability
    
    # Prepare payload
    payload = {
        "north": coordinates["north"],
        "south": coordinates["south"],
        "east": coordinates["east"],
        "west": coordinates["west"],
        "startYear": start_year,
        "endYear": end_year,
        "scale": scale  # Add scale parameter to reduce resolution if supported by API
    }
    
    # Calculate approximate area and pixels
    lat_diff = abs(coordinates["north"] - coordinates["south"])
    lon_diff = abs(coordinates["east"] - coordinates["west"])
    area_km2 = lat_diff * lon_diff * 111 * 111  # Rough approximation: 1 degree ≈ 111 km
    pixels_estimate = (area_km2 * 1000000) / (scale * scale)  # Rough pixel count estimate
    
    print(f"\n\n{'='*50}")
    print(f"Testing /api/analyze endpoint with:")
    print(f"Coordinates: N: {coordinates['north']}, S: {coordinates['south']}, E: {coordinates['east']}, W: {coordinates['west']}")
    print(f"Time Period: {start_year} to {end_year}")
    print(f"Estimated area: {area_km2:.2f} km² (approximately {pixels_estimate:,.0f} pixels at {scale}m resolution)")
    
    if pixels_estimate > 10000000:
        print(f"⚠️ WARNING: Region may be too large! Estimated pixels: {pixels_estimate:,.0f}, max allowed: 10,000,000")
        print(f"Consider using a smaller region or increasing scale value (currently {scale}m)")
    
    print(f"{'='*50}\n")
    
    try:
        # Make the API request
        print("Sending request to API...")
        start_time = time.time()
        response = requests.post(ANALYZE_API, json=payload)
        elapsed_time = time.time() - start_time
        
        # Check if the request was successful
        if response.status_code == 200:
            print(f"✅ Request successful (Status: {response.status_code})")
            print(f"⏱️ Request took {elapsed_time:.2f} seconds")
            
            # Parse and return the response data
            data = response.json()
            
            # Print formatted results
            print("\n📊 NDVI Analysis Results:")
            print(f"  Start Year NDVI: {data.get('startNDVI', 'N/A'):.4f}")
            print(f"  End Year NDVI: {data.get('endNDVI', 'N/A'):.4f}")
            print(f"  NDVI Change: {data.get('ndviChange', 'N/A'):.4f}")
            print(f"  Change Category: {data.get('changeCategory', 'N/A')}")
            
            # Print map URLs
            print("\n🗺️ Map URLs:")
            map_urls = data.get('mapUrls', {})
            for key, url in map_urls.items():
                print(f"  {key}: {url[:60]}...")
            
            return data
            
        else:
            print(f"❌ Request failed with status code: {response.status_code}")
            print(f"Response: {response.text}")
            
            # Check for specific error types
            if "maxPixels" in response.text:
                print("\n⚠️ ERROR: The region is too large for analysis.")
                print("Try one of these solutions:")
                print("1. Reduce the size of your region (use a smaller area)")
                print("2. Try again with a higher scale value (lower resolution)")
                print(f"   Example: python test.py {coordinates['north']} {coordinates['south']} {coordinates['east']} {coordinates['west']} {start_year} {end_year} 100")
            elif "No satellite imagery available" in response.text:
                print("\n⚠️ ERROR: No satellite imagery available for this area and time period.")
                print("Try one of these solutions:")
                print("1. Use a different time period (2015-2022 generally has good Landsat 8 coverage)")
                print("2. Try a different geographic region with better satellite coverage")
                print("3. Expand the area slightly to increase chances of finding imagery")
                print(f"   Example: python test.py {coordinates['north']+0.1} {coordinates['south']-0.1} {coordinates['east']+0.1} {coordinates['west']-0.1} 2015 2022")
            
            return None
            
    except Exception as e:
        print(f"❌ An error occurred: {str(e)}")
        return None

def run_tests():
    """Run a series of tests with different coordinates"""
    
    # Test 1: USA agricultural region (Kansas) - good Landsat 8 coverage
    kansas_coordinates = {
        "north": 39.55,
        "south": 39.45,
        "east": -96.45,
        "west": -96.55
    }
    test_analyze_api(kansas_coordinates, 2015, 2022)
    
    # Test 2: Brazil rainforest/agricultural boundary - known good coverage
    brazil_coordinates = {
        "north": -10.20,
        "south": -10.30,
        "east": -56.40,
        "west": -56.50
    }
    test_analyze_api(brazil_coordinates, 2015, 2022)
    
    # Test 3: Australia agricultural region - good Landsat 8 coverage
    australia_coordinates = {
        "north": -34.20,
        "south": -34.30,
        "east": 140.90,
        "west": 140.80
    }
    test_analyze_api(australia_coordinates, 2015, 2022)

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--run-all":
        # Run all predefined tests
        run_tests()
    else:
        # Run a single test with custom coordinates
        print("Testing vegetation analysis API with a sample region...")
        
        # Default coordinates: Agricultural region in Kansas (good satellite coverage)
        coordinates = {
            "north": 39.55,
            "south": 39.45,
            "east": -96.45,
            "west": -96.55
        }
        
        # Allow custom coordinates from command line
        if len(sys.argv) >= 5:
            try:
                coordinates = {
                    "north": float(sys.argv[1]),
                    "south": float(sys.argv[2]),
                    "east": float(sys.argv[3]),
                    "west": float(sys.argv[4])
                }
            except ValueError:
                print("Invalid coordinates. Using default values.")
        
        # Allow custom years and scale
        start_year = int(sys.argv[5]) if len(sys.argv) >= 6 else 2015  # Default to 2015
        end_year = int(sys.argv[6]) if len(sys.argv) >= 7 else 2022    # Default to 2022
        scale = int(sys.argv[7]) if len(sys.argv) >= 8 else 30         # Default 30m resolution
        
        # Run the test
        test_analyze_api(coordinates, start_year, end_year, scale) 