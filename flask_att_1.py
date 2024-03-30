from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
import speech_recognition as sr
import google.generativeai as genai

app = Flask(__name__)

# Configure generative AI
genai.configure(api_key="AIzaSyDZ7q5vFZARCv2nShdqnjqE4K7dh3z23PU")
model = genai.GenerativeModel('gemini-pro')

# Function to recognize speech from uploaded audio file
def recognize_speech(audio_file):
    r = sr.Recognizer()
    with sr.AudioFile(audio_file) as source:
        audio = r.record(source)
    try:
        query = r.recognize_google(audio, language='en-IN')
        if query:
            response = model.generate_content(query)
            # print(response.text)
            return response.text
    except sr.UnknownValueError:
        return "Sorry, I couldn't understand. Please repeat."
    except sr.RequestError as e:
        return "Google Speech Recognition service is not available. {0}".format(e)

# Route to handle file upload
@app.route('/upload', methods=['POST'])
def upload_file():
    if 'audio_file' not in request.files:
        return jsonify({'error': 'No file part'})

    audio_file = request.files['audio_file']

    if audio_file.filename == '':
        return jsonify({'error': 'No selected file'})

    if audio_file:
        filename = secure_filename(audio_file.filename)
        
        # Extract file extension from the filename
        file_extension = filename.rsplit('.', 1)[1].lower()
        print(file_extension)
        # Now you can check the file type based on the extension
        if file_extension in ['mp3', 'wav', 'ogg']:
            # It's an audio file
            audio_file.save(filename)
            # result = recognize_speech(filename)
            return jsonify({'file_type': file_extension})
        else:
            # It's not an audio file
            return jsonify({'error': 'Unsupported file type'})
    
@app.route('/', methods=['GET'])
def index():
    return "Hello, World!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)