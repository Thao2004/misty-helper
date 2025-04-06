import requests
import time
from datetime import datetime
from mistyPy.Robot import Robot
from config import MISTY_IP, API_BASE, ROBOT

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
        time.sleep(30)  # poll every 30 seconds

def run_checkup(checkup):
    questions = eval(checkup['questions'])  # WARNING: use json.loads if safe
    measure_temp = checkup['measure_temperature']
    checkup_id = checkup['id']
    answers = {}

    ROBOT.speak("Hello! It's time for your checkup.")
    get_photo()

    for q in questions:
        ROBOT.speak(q)
        print(f"Asking: {q}")
        time.sleep(2)
        audio_path = ROBOT.capture_speech_google()
        answer_text = "sample answer"  # TODO: use speech-to-text if not already
        answers[q] = answer_text

    temp = None
    if measure_temp:
        ROBOT.speak("Let me check your temperature.")
        temp = get_temperature()
        ROBOT.speak(f"Your temperature is {temp} degrees.")

    ROBOT.speak("Thank you! Sending your checkup results now.")

    # Send to backend
    payload = {
        "checkup": checkup_id,
        "responses": str(answers),  # or use json.dumps()
        "temperature": temp,
    }

    try:
        r = requests.post(f"{API_BASE}/checkup/response/", json=payload)
        print("Submitted checkup:", r.status_code)
    except Exception as e:
        print("Failed to submit checkup:", e)

def get_temperature():
    temp = ROBOT.get_subject_temperature()
    if temp:
        return temp.get("temperature")

    return None    

def get_photo():
    photo = ROBOT.take_picture()
    if photo:
        return photo.get("base64")
    return None

if __name__ == "__main__":
    poll_checkups()

