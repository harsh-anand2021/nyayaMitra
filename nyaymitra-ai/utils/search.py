import os
import json
import chromadb
from chromadb.utils.embedding_functions import SentenceTransformerEmbeddingFunction

# ✅ Step 1: Initialize persistent Chroma client
chroma_client = chromadb.PersistentClient(path="./chroma_store")

# ✅ Step 2: Setup embedding function
embedding_function = SentenceTransformerEmbeddingFunction(model_name="all-MiniLM-L6-v2")

# ✅ Step 3: Create (or recreate) collection
collection_name = "nyaymitra_qa"

# Remove existing collection if needed
if any(c.name == collection_name for c in chroma_client.list_collections()):
    chroma_client.delete_collection(name=collection_name)

# ✅ Step 4: Create collection with embedding function
collection = chroma_client.create_collection(
    name=collection_name,
    embedding_function=embedding_function
)

# ✅ Step 5: Load JSON file in new Q&A format
with open("data/bns_questions.json", "r", encoding="utf-8") as f:
    data = json.load(f)

# ✅ Step 6: Prepare and insert data
ids = []
documents = []
metadatas = []

for section in data:
    section_number = section.get("section")
    section_name = section.get("section_name")
    questions = section.get("questions", [])

    for i, q in enumerate(questions):
        question = q.get("question")
        answer = q.get("answer")
        doc_id = f"sec{section_number}_q{i+1}"

        ids.append(doc_id)
        documents.append(answer)
        metadatas.append({
            "section": section_number,
            "section_name": section_name,
            "question": question
        })

collection.add(
    ids=ids,
    documents=documents,
    metadatas=metadatas
)

print(f"✅ Successfully inserted {len(documents)} records into ChromaDB.")
# Add this at the bottom of your search.py file

def search_law(query: str):
    collection = chroma_client.get_collection(
        name=collection_name,
        embedding_function=embedding_function
    )

    results = collection.query(
        query_texts=[query],
        n_results=1
    )

    if results["documents"] and results["documents"][0]:
        matched_answer = results["documents"][0][0]
        matched_metadata = results["metadatas"][0][0]
        context = f"Section {matched_metadata['section']}: {matched_metadata['section_name']} - Question: {matched_metadata['question']}"
        return matched_answer, context
    else:
        return "Sorry, I could not find any relevant information.", ""
