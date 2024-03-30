from click import File
from fastapi import FastAPI, UploadFile
import uvicorn
import speech_recognition as sr
import pyttsx3
from IPython.display import Markdown
from IPython.display import display
import textwrap
import google.generativeai as genai
genai.configure(api_key="AIzaSyDZ7q5vFZARCv2nShdqnjqE4K7dh3z23PU")
model = genai.GenerativeModel('gemini-pro')
app = FastAPI()

@app.post("/process_audio")
async def process_audio(audio_file: UploadFile = File(...)):
    # Read audio data from the uploaded file
    audio_data = await audio_file.read()
    command = takeCommand(audio_data)
    # Pass audio data to your existing speech recognition function
    if command:
        response = model.generate_content(command)
    #Process the command and generate a response using your existing logic
    return {"response": response}

def takeCommand(mp3_file_path):
    r = sr.Recognizer()
    with sr.AudioFile(mp3_file_path) as source:
        audio = r.record(source)
    try:
        print("Recognizing...")
        query = r.recognize_google(audio, language='en-IN')
        print(f"User said: {query}")
        return query
    except sr.UnknownValueError:
        print("Sorry, I couldn't understand. Please repeat.")
        return ""
    except sr.RequestError as e:
        print("Google Speech Recognition service is not available. {0}".format(e))
    return ""