import requests

# URL of your FastAPI server
url = "http://localhost:8000/generate"

# Example prompt to send
prompt = "Write a short poem about AI"

# Send GET request with the prompt
response = requests.get(url, params={"prompt": prompt})

# Print the output
print(response.json())
