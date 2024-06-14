# app.py
from flask import Flask, render_template, request, jsonify
import google.generativeai as genai

app = Flask(__name__)

# Configure Google Generative AI API with the Gemini API key
API_KEY = 'AIzaSyCCrYnLhDIgToWeG4u_nPpQcB9uNJMze0U'
genai.configure(api_key=API_KEY)

# Initialize GenerativeModel
model = genai.GenerativeModel('gemini-pro')
chat = model.start_chat(history=[])
instruction = "In this chat, respond as if you're explaining about a cooking related queries only."

# Route for home page
@app.route('/')
def home():
    return render_template('chat.html')

# Route to handle user queries
@app.route('/ask', methods=['POST'])
def ask():
    user_message = str(request.form['messageText'])

    # Pass user message to Gemini chat model
    bot_response = chat.send_message(user_message)
    
    return jsonify({'status': 'OK', 'answer': bot_response.text})

if __name__ == '__main__':
    app.run(debug=True, port=7898)
