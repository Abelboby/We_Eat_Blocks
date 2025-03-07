# Vegetation Analysis Web Application

This application uses Google Earth Engine to analyze vegetation changes over time using NDVI (Normalized Difference Vegetation Index).

## Local Development Setup

1. Install dependencies:
```
pip install -r requirements.txt
```

2. Place your Google Earth Engine service account JSON file in the root directory as `serviceAccount.json`

3. Run the application:
```
python app.py
```

## Deploying to Render

1. Create a new Web Service on Render
2. Connect your GitHub repository
3. Configure the following settings:
   - **Environment**: Python
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `gunicorn app:app`

4. Add the following environment variable:
   - Key: `GEE_SERVICE_ACCOUNT_FILE`
   - Value: `/etc/secrets/serviceAccount.json`

5. Add a secret file:
   - File Path: `/etc/secrets/serviceAccount.json`
   - File Contents: Copy and paste the entire contents of your `serviceAccount.json` file

## Google Earth Engine Authentication

For the application to work properly, you need a Google Earth Engine service account:

1. Create a service account in the Google Cloud Console
2. Enable the Earth Engine API for your project
3. Grant the service account access to Earth Engine
4. Download the service account key as JSON
5. Use this JSON file as described above for authentication

## Additional Configuration

If you need to specify different origins for CORS, modify the CORS configuration in `app.py`.

## Important Note

Make sure your service account has the necessary permissions to access Google Earth Engine and that it has been added to your Earth Engine project. 