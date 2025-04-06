import time
import os, sys
import re
import threading

# Imports the Google Generative AI library
from google.cloud import aiplatform as vertexai
from vertexai.generative_models import GenerativeModel, ChatSession

#Import local files
from mistyPy.Robot import Robot
from mistyPy.Events import Events
from helper.tts_helper import text_to_speech



# from google.colab import userdata
PROJECT_ID = "misty-440915"
vertexai.init(project=PROJECT_ID, location="us-central1")
model = GenerativeModel("gemini-2.0-flash-001")
chat_session = model.start_chat()

#USER
current_user = "Chi"

#TO DO: Misty look around to detect face
looking_for_face = True
count = 0

# Variables for double press to detect end of conversation
press_count = 0
last_press_time = 0
double_press_interval = 1
interrupt = False


# OLLAMA
system = "you are a friendly and helpful assistant " 

emotion = {
    "s": "sad",
    "h": "happy",
    "r": "rage",
    "f": "fear",
    "l": "love",
    "g": "grief"
}

#Variable to control if the audio is finished playing
audio_finished = False

#Misty listens for a face detection event
def face_detected():
    global looking_for_face
    looking_for_face = False  # Stop looking for a face
    misty.stop_face_detection()  # Stop face recognition
    return "Face detected"

#Call back function for when Misty captures speech
def speech_captured(data):
    if data["message"]["step"] == "CompletedASR":
        #Get the speech from the data (Misty built-in)
        user_input = data["message"]["text"]
        print("Receive speech: ", user_input)
        if user_input == "":
            speak_and_listen("I didn't catch that. Could you please repeat?")
        else:
            response_from_gemini(user_input)
   
def response_from_gemini(message):
    global interrupt
    global count
    global audio_finished
    if not count:
        response = chat_session.send_message(system+message, stream=True)
        count = 1
    else:
        response = chat_session.send_message(message, stream=True)
    text = ""
    for chunk in response:
        text += chunk.text
    # # Regular expression to find markers and sentences
    matches = re.findall(r'\*(.*?)\*\s*([^*]+)', text)
    next_audio = None

    # # Print the marker and its corresponding sentence on each line
    save = ""
    for i in range(len(matches)):
        marker, sentence = matches[i]
        if interrupt:
            print("------Being interrupted. Stop getting response from Gemini-----")
            return
        if marker in emotion and marker != save:
            print(f"*show {emotion[marker]}*")
            threading.Thread(target=show_emotion, args=(marker,)).start()
            save = marker
        if sentence != "":
            audio_finished = False
            print(sentence)
            if next_audio is None:
                audio_content = text_to_speech(sentence)
            else:
                audio_content = next_audio
                next_audio = None

            misty.save_audio(fileName=f"output.mp3", data=audio_content, immediatelyApply=True, overwriteExisting=True)

            while not audio_finished:
                if next_audio is None and i + 1 < len(matches):
                    next_audio = text_to_speech(matches[i+1][1])

    listen()

def show_emotion(emotion):
    if emotion == "h":
        misty.display_image("e_Joy.jpg")
        misty.transition_led(0, 0, 255, 40, 0, 112, 1200, "breathe")
        misty.change_led(255, 255, 255)
        misty.move_arms(-89, -89, 50)
        time.sleep(2)
        misty.change_led(100, 70, 255)
        misty.move_arms(89, 89, 50)
        misty.move_head(-5, 25, 0, 500)
    elif emotion == "s":
        misty.display_image("e_Sadness.jpg")
        misty.transition_led(0, 0, 255, 40, 0, 112, 1200, "breathe")
        misty.move_arms(89, -89, 50)
        misty.move_head(10, 0, -30, 80)
    elif emotion == "r":
        misty.display_image("e_Rage2.jpg")
        misty.transition_led(0,255,0,0,0,0,200,"blink")
        misty.move_head(5,0,0,500)
        time.sleep(0.7)
        misty.move_head(-10,0,0,500)
        time.sleep(0.7)
        misty.move_head(5,0,0,500)
        time.sleep(0.7)
        misty.move_head(-10,0,0,500)
        time.sleep(0.7)
        misty.move_head(5,0,0,500)
        time.sleep(0.7)
        misty.move_head(-10,0,0,500)
    elif emotion == "f":
        misty.display_image("e_Fear.jpg")
        misty.move_arms(89, -89, 300)
        misty.move_head(-10,0,0,300)
    elif emotion == "l":
        misty.display_image("e_Love.jpg")
        misty.transition_led(255,0,0,150,0,0,1200,"breathe")
        misty.move_arms(-89, 89, 50)
        misty.move_head(-5,-10,3,700)
    elif emotion == "g":
        misty.display_image("e_Grief.jpg")
        misty.move_arms(89, -89, 50)
        misty.move_head(10,0,0,3000)
        misty.transition_led(0,0,255,40,0,112,1200,"breathe")
        time.sleep(2)
    else:
        reset_pose()
    time.sleep(2)
    reset_pose()

def reset_pose():
    misty.move_arms(90, 90)
    misty.move_head(0,0,0)
    misty.transition_led(0, 0, 255, 40, 0, 112, 1200, "breathe")
    misty.change_led(255, 255, 255)


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

def bump_sensor(data):
    if data['message']['isContacted'] and data['message']["sensorId"] == "bfr":
        stop_storytelling()
    elif data['message']['isContacted'] and data['message']["sensorId"] == "bfl":
        interrupt_storytelling()

def interrupt_storytelling():
    print("Left bump sensor pressed - interrupting") 
    global audio_finished, interrupt

    for volume in range(50, 0, -15):
        misty.set_default_volume(volume)
        time.sleep(0.1)

    interrupt = True
    audio_finished = True
    misty.set_default_volume(50)
    speak_and_listen("It seems like you have something to say. I'm listening")
    interrupt = False
    print("Turn off interrupt mode")


def stop_storytelling():
    print("Right bump sensor pressed - stopping")
    global audio_finished, interrupt
    interrupt = True

    # Fade out volume
    for volume in range(50, 0, -15):
        misty.set_default_volume(volume)
        time.sleep(0.1)

    # Stop all current processes
    audio_finished = True
    misty.set_default_volume(50)
    misty.stop_face_detection()
    misty.stop_dialog()
    
    # Unregister all events
    misty.unregister_all_events()
    
    # Say goodbye
    speak("Alright, it seems that you are done with the conversation. Have a great day!")
    
    # Reset to default expression
    misty.display_image("e_DefaultContent.jpg")
    
    # Sleep briefly to ensure goodbye message is played
    time.sleep(3)
    
    # Exit the program
    sys.exit()
    print("Storytelling stopped---------")

def reset_press_count():
    global press_count, last_press_time
    press_count = 0
    last_press_time = 0

if __name__ == "__main__":
    ip_address = "10.226.140.154"
    misty = Robot(ip_address)
    while looking_for_face:
        misty.start_face_detection()
        if misty.get_known_faces() is not None:
            face_detected()
            print("Face detected")
            break
        else:
            print("Looking for face...")
            continue
    misty.display_image("e_Joy.jpg")
    misty.register_event(event_name="arbitrary-name",
                     event_type=Events.DialogAction,
                     callback_function=speech_captured,
                     keep_alive=True)
    misty.register_event(event_name="AudioPlayComplete", event_type=Events.AudioPlayComplete, callback_function=audio_play_complete, keep_alive=True)
    misty.register_event(event_name="BumpSensor", event_type=Events.BumpSensor, callback_function=bump_sensor, keep_alive=True)
    misty.start_dialog()
    misty.set_default_volume(50)

    with open("intro-session.txt", "r") as file:
        introduction = file.read()
        str_to_speak = "Hi" + current_user + " " + introduction
    speak_and_listen(str_to_speak)
