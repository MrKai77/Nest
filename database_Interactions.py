from supabase import create_client, Client
import os

SUPABASE_URL = "https://kivxwcoopuuuntchneta.supabase.co"
SUPABASE_KEY = os.environ["SUPABASE_KEY"]  # same env var concept

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)


