import speech_recognition as sr
import pyttsx3
from IPython.display import Markdown
from IPython.display import display
import textwrap
import google.generativeai as genai
genai.configure(api_key="AIzaSyDZ7q5vFZARCv2nShdqnjqE4K7dh3z23PU")
model = genai.GenerativeModel('gemini-pro')
def takeCommand(mp3_file_path):
    r = sr.Recognizer()
    with sr.AudioFile(mp3_file_path) as source:
        audio = r.record(source)
    '''with sr.Microphone() as source:
        # Adjust microphone sensitivity (optional)
        r.adjust_for_ambient_noise(source)  # Adjust for ambient noise
        print("Listening...")
        audio = r.listen(source)'''
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

def say(text):
    engine = pyttsx3.init()
    engine.say(text)
    engine.runAndWait()
def to_markdown(text):
  text = text.replace('•', '  *')
  return Markdown(textwrap.indent(text, '> ', predicate=lambda _: True))
print('pinky')
say("Hello, I am ready to listen.")  

# Continuously listen for commands
while True:
    #command = takeCommand()
    mp3_file_path = "WhatsApp Ptt 2024-03-30 at 1.11.21 PM.wav"
    command = takeCommand(mp3_file_path)
    if command:
        response = model.generate_content(command)
        print(response.text)
    if "stop" in command.lower():
        say("Goodbye!")
        break