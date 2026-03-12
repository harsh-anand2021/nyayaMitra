# utils/llm_helper.py
import google.generativeai as genai
import os
from dotenv import load_dotenv

load_dotenv()

GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")
genai.configure(api_key=GOOGLE_API_KEY)

model = genai.GenerativeModel(model_name="gemini-1.5-flash")

def ask_gemini(context: str, query: str) -> str:
    prompt = f"Use the context below to answer the question in a simple and helpful tone:\n\nContext:\n{context}\n\nQuestion: {query}"
    try:
        response = model.generate_content(prompt)
        return response.text
    except Exception as e:
        return f"❌ Gemini Error: {str(e)}"