# LovableLobsterMobsters

## Running

1. Make a virtual environment: `python -m venv venv`
2. Activate virtual environment: `venv\Scripts\activate` or `source venv/bin/activate` (UNIX)
3. Install dependencies: `pip install -r requirements.txt`
4. Run: `uvicorn app:app --host 0.0.0.0 --port 8080`