import requests
import queue
import threading
import time
import base64

from google.cloud import speech
#Import local files
from mistyPy.Robot import Robot
from mistyPy.Events import Events
from helper.general_helper import transcribe_audio_file, transcribe_streaming


# Imports the Google Cloud client library

#API ENDPOINT
url = "https://chatgpt-api7.p.rapidapi.com/ask"
#TO DO: Misty look around to detect face
looking_for_face = True

#Misty listens for a face detection event
def face_detected():
    global looking_for_face
    looking_for_face = False  # Stop looking for a face
    misty.stop_face_detection()  # Stop face recognition
    misty.speak("Hello! Ask me to tell you a story.")
    return "Face detected"


#Misty listens for a voice command
#if Misty hears "tell me a story" or something similar, she will call the get_story function
#if not, she will ask the user to ask her to tell a story
def voice_command(data):
    print("Voice command received")
    if data["message"]["success"]:
        file_path = data["message"]["filename"]
        speech = transcribe_audio_file(file_path)
  
        if "tell me a story" or "story" in speech.lower():
            misty.speak("Sure! What kind of story would you like to hear?")
            misty.register_event("VoiceRecord", "VoiceRecord", 1000, True, tell_story)
        else:
            misty.speak("I'm sorry, I didn't understand that. Please ask me to tell you a story.")
            misty.register_event("VoiceRecord", "VoiceRecord", 1000, True, voice_command)
        return "Voice command received"

#Misty listens for the type of story the user wants to hear
#Misty will then call the get_story function with the user's input -> tell the story
def tell_story(data):
    if data["message"]["success"]:
        file_path = data["message"]["filename"]
        speech = transcribe_audio_file(file_path)
        misty.speak("Let me think of a story for you.")
        story = get_story(speech)
        misty.speak(story["response"])
        misty.speak("What a great story! I hope you enjoyed it.")
        misty.register_event("VoiceRecord", "VoiceRecord", 1000, True, voice_command)


#Description: This function sends a prompt to the GPT-3 API and returns the response
def get_story(prompt: str):
    prompt = "Tell me a story about a " + prompt
    payload = { "query": prompt }
    headers = {
	"content-type": "application/json",
	"X-RapidAPI-Key": "f714455552msh5f404df2a023ebdp1346c2jsn0cb1481c199f",
	"X-RapidAPI-Host": "chatgpt-api7.p.rapidapi.com"
    }
    response = requests.post(url, json=payload, headers=headers)
    return response.json()





if __name__ == "__main__":
    ip_address = "10.247.153.203"
    misty = Robot(ip_address)
    response = (misty.get_audio_list())
    print(response.json())



        



