import time
import os, sys
import re
import threading
import json
import requests

# Imports the Google Generative AI library
from google.cloud import aiplatform as vertexai
from vertexai.generative_models import GenerativeModel, ChatSession

#Import local files
from mistyPy.Robot import Robot
from mistyPy.Events import Events
from helper.tts_helper import text_to_speech

API_BASE = "http://10.226.162.163:8000/api"

# Holds the user’s spoken answer temporarily
speech_result = None

def poll_checkups():
    while True:
        try:
            res = requests.get(f"{API_BASE}/checkup/due/")
            checkups = res.json()
            if checkups:
                print("Found checkup!", checkups[0])
                run_checkup(checkups[0])
        except Exception as e:
            print("Error checking for checkups:", e)
        time.sleep(30)

def run_checkup(checkup):
    global speech_result
    questions = json.loads(checkup['questions'])  # always use json.loads instead of eval
    measure_temp = checkup['measure_temperature']
    checkup_id = checkup['id']
    answers = {}

    speak("Hello! It's time for your checkup.")
    take_photo()

    for q in questions:
        speak(q)
        print(f"Asking: {q}")
        time.sleep(2)
        speech_result = None
        listen()
        answer_text = wait_for_response(timeout=10)
        print(f"Answer: {answer_text}")
        answers[q] = answer_text or "No response"

    temp = None
    if measure_temp:
        speak("Let me check your temperature.")
        temp = get_temperature()
        speak(f"Your temperature is {temp} degrees.")

    speak("Thank you! Sending your checkup results now.")

    payload = {
        "checkup": checkup_id,
        "responses": json.dumps(answers),
        "temperature": temp,
    }

    try:
        r = requests.post(f"{API_BASE}/checkup/response/", json=payload)
        print("Submitted checkup:", r.status_code)
    except Exception as e:
        print("Failed to submit checkup:", e)

# ========== Helper Functions ==========

def wait_for_response(timeout=10):
    """Waits for speech_result to be populated from the speech_captured callback."""
    global speech_result
    waited = 0
    while waited < timeout:
        if speech_result:
            response = speech_result
            speech_result = None
            return response
        time.sleep(1)
        waited += 1
    return None

def speech_captured(data):
    """Captures user's spoken response."""
    global speech_result
    if data["message"]["step"] == "CompletedASR":
        user_input = data["message"]["text"]
        print("Received speech:", user_input)
        if user_input == "":
            speak_and_listen("I didn't catch that. Could you please repeat?")
        else:
            speech_result = user_input

def get_temperature():
    # Fake temperature reading; replace with actual sensor code
    return 36.8

def take_photo():
    # Replace with actual photo logic if desired
    misty.take_picture()
    print("Photo taken.")

def speak_and_listen(text:str):
    audio_content = text_to_speech(text)
    misty.save_audio(fileName="output.mp3", data=audio_content, immediatelyApply=False, overwriteExisting=True)
    misty.play_and_listen(audioFile="output.mp3")

def speak(text:str):
    audio_content = text_to_speech(text)
    misty.save_audio(fileName=f"output.mp3", data=audio_content, immediatelyApply=True, overwriteExisting=True)

def listen():
    print("Listening...")
    misty.play_and_listen(audioFile='silent_audio.wav')

def audio_play_complete(data):
    global audio_finished
    print("Audio playback completed")
    audio_finished = True

if __name__ == "__main__":
    # Start polling for checkups
    ip_address = "10.226.140.154"
    misty = Robot(ip_address)
    misty.register_event(event_name="arbitrary-name",
                     event_type=Events.DialogAction,
                     callback_function=speech_captured,
                     keep_alive=True)
    misty.register_event(event_name="AudioPlayComplete", event_type=Events.AudioPlayComplete, callback_function=audio_play_complete, keep_alive=True)
    poll_checkups()
