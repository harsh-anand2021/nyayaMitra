# app.py
from utils.llm_helper import ask_gemini
from utils.search import search_law

def chatbot():
    print("NyayMitra-AI: Ask your legal questions (type 'exit' to quit)\n")
    while True:
        user_input = input("You: ").strip()
        if user_input.lower() == "exit":
            print("Goodbye! 👋")
            break

        result, context = search_law(user_input)
        if not context:
            print("NyayMitra: ❌ No relevant legal section found in the database.")
            continue

        answer = ask_gemini(context, user_input)
        print(f"\nNyayMitra: {answer}\n")

if __name__ == "__main__":
    chatbot()
