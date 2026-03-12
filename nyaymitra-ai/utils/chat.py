from utils.embedder import get_embedding
import chromadb
import google.generativeai as genai
import os

genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))
model = genai.GenerativeModel("gemini-pro")

chroma_client = chromadb.PersistentClient(path="chroma_store")
collection = chroma_client.get_collection("legal_data")

def search_similar_context(query, k=3):
    embedding = get_embedding(query)
    results = collection.query(query_embeddings=[embedding], n_results=k)
    return results["documents"][0]  # top-k most relevant document texts

def ask_gemini_with_context(query):
    context_docs = search_similar_context(query)
    context = "\n".join(context_docs)
    prompt = f"""Answer the question using the following legal context:

{context}

Question: {query}
Answer:"""
    response = model.generate_content(prompt)
    return response.text.strip()
