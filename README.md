NyayaMitra – AI Legal Assistant

NyayaMitra is an AI-powered legal assistant designed to help users understand legal concepts, explore case precedents, and get guidance on Indian laws. The application combines a cross-platform mobile interface with an AI backend to deliver intelligent legal responses.

The system uses vector search and LLM-based reasoning to provide contextual legal information.

Features

• AI powered legal chatbot
• Search legal questions based on BNS sections
• Retrieve case precedents using vector search
• Save and view previous responses
• Mobile-friendly Flutter interface
• Light and dark theme support
• Secure user authentication
• Responsive UI for mobile and web

Tech Stack

Frontend
• Flutter

Backend
• FastAPI

AI / ML
• Sentence Transformers
• ChromaDB
• Google Gemini

Database / Storage
• JSON knowledge base

Project Structure
NyayaMitra
│
├── nyayamitra (Flutter App)
│   ├── lib
│   ├── assets
│   ├── android
│   └── ios
│
├── nyaymitra-ai (AI Backend)
│   ├── app.py
│   ├── utils
│   ├── data
│   └── requirements.txt
│
├── screenshots
└── README.md
## Application Screenshots

### Welcome Page
![Welcome](screenshots/WelcomePage.jpg)

### Login Page
![Login](screenshots/loginPage.jpg)

### Mobile Login
![Mobile Login](screenshots/mobileLogin.jpg)

### Sign Up Page
![Signup](screenshots/SignUp.jpg)

### Light Theme Operation Page
![Light Theme](screenshots/lightOpPage.jpg)

### Dark Theme
![Dark Theme](screenshots/darkTheme.jpg)

### Mobile Welcome Screen
![Mobile Welcome](screenshots/mobileWelcome.jpg)

### Mobile Operation Screen
![Mobile OP](screenshots/MobileOpScreen.jpg)

### Sample Legal Query
![Sample Query](screenshots/sampleOP.jpg)

### Recent Responses
![Recent Responses](screenshots/recentResponse.jpg)

### Alert Messages
![Alert](screenshots/alert.jpg)

### Logout Screen
![Logout](screenshots/logout.jpg)

### Our Team
![Team](screenshots/ourTeam.jpg)

How to Run the Project
1 Clone the Repository
git clone https://github.com/harsh-anand2021/nyayaMitra.git
cd nyayaMitra
Backend Setup

Navigate to backend folder:

cd nyaymitra-ai

Create virtual environment

python -m venv venv

Activate environment

Windows

venv\Scripts\activate

Install dependencies

pip install -r requirements.txt

Run the backend server

python app.py

Backend will start on

http://127.0.0.1:8000
Flutter App Setup

Navigate to Flutter project

cd nyayamitra

Install dependencies

flutter pub get

Run the app

flutter run
AI Pipeline

The AI response system follows this architecture:

User Query
↓
Embedding using Sentence Transformers
↓
Vector search using ChromaDB
↓
Context retrieval from legal dataset
↓
LLM response generation using Gemini
↓
Response displayed in Flutter UI

Future Improvements

• Add more legal datasets
• Improve LLM response accuracy
• Deploy backend to cloud
• Add multilingual legal support
• Implement voice-based queries

Harsh Anand
GitHub: https://github.com/harsh-anand2021

LinkedIn: https://www.linkedin.com/in/harsh-anand-019970264

License

This project is for educational and research purposes.
