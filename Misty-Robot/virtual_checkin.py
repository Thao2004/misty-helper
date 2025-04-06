# import requests
# import time
# from datetime import datetime
# from mistyPy.Robot import Robot
# from config import MISTY_IP, API_BASE, ROBOT

# def poll_checkups():
#     while True:
#         try:
#             res = requests.get(f"{API_BASE}/checkup/due/")
#             checkups = res.json()
#             if checkups:
#                 print("Found checkup!", checkups[0])
#                 run_checkup(checkups[0])
#         except Exception as e:
#             print("Error checking for checkups:", e)
#         time.sleep(30)  # poll every 30 seconds

# def run_checkup(checkup):
#     questions = eval(checkup['questions'])  # WARNING: use json.loads if safe
#     measure_temp = checkup['measure_temperature']
#     checkup_id = checkup['id']
#     answers = {}

#     ROBOT.speak("Hello! It's time for your checkup.")
#     get_photo()

#     for q in questions:
#         ROBOT.speak(q)
#         print(f"Asking: {q}")
#         time.sleep(2)
#         audio_path = ROBOT.capture_speech_google()
#         answer_text = "sample answer"  # TODO: use speech-to-text if not already
#         answers[q] = answer_text

#     temp = None
#     if measure_temp:
#         ROBOT.speak("Let me check your temperature.")
#         temp = get_temperature()
#         ROBOT.speak(f"Your temperature is {temp} degrees.")

#     ROBOT.speak("Thank you! Sending your checkup results now.")

#     # Send to backend
#     payload = {
#         "checkup": checkup_id,
#         "responses": str(answers),  # or use json.dumps()
#         "temperature": temp,
#     }

#     try:
#         r = requests.post(f"{API_BASE}/checkup/response/", json=payload)
#         print("Submitted checkup:", r.status_code)
#     except Exception as e:
#         print("Failed to submit checkup:", e)

# def get_temperature():
#     temp = ROBOT.get_subject_temperature()
#     if temp:
#         return temp.get("temperature")

#     return None    

# def get_photo():
#     photo = ROBOT.take_picture()
#     if photo:
#         return photo.get("base64")
#     return None

# if __name__ == "__main__":
#     poll_checkups()

 ##############################################################
import time
import json
import asyncio
import requests
from datetime import datetime, timedelta
from typing import List, Dict, Optional
import sys
from mistyPy.Robot import Robot
from mistyPy.Events import Events
from helper.tts_helper import text_to_speech

from config import MISTY_IP, BACKEND_URL, CHECKUP_POLL_INTERVAL

responses = {}
class VirtualCheckIn:
    def __init__(self, misty: Robot, backend_url: str):
        self.misty = misty
        self.backend_url = backend_url
        self._setup_event_handlers()
        
        # Variables for response handling
        self.current_response = None
        self.response_received = asyncio.Event()
        self.audio_finished = False
        self.temperature_reading = None
        self.photo_data = None

    def _setup_event_handlers(self):
        """Setup event handlers for Misty's sensors and capabilities"""
        self.misty.register_event(Events.KeyPhraseRecognized, self._speech_captured)
        self.misty.register_event(Events.AudioPlayComplete, self._audio_play_complete)
        self.misty.register_event(Events.TimeOfFlight, self._temperature_reading)
        # self.misty.register_event(Events.PhotoTaken, self._photo_taken)

    async def get_due_checkups(self) -> List[Dict]:
        """Get checkups that are due to be performed"""
        try:
            response = requests.get(f"{self.backend_url}/checkup/due/")
            if response.status_code == 200:
                return response.json()
            return []
        except Exception as e:
            print(f"Error getting due checkups: {e}")
            return []

    async def start_checkup(self, checkup_id: str):
        """Start the virtual checkup process"""
        # Check if patient is ready
        self.speak_and_listen("Hello! Are you ready for your checkup now?")
        response = await self._wait_for_response()
        
        if "yes" in response.lower():
            await self._conduct_checkup(checkup_id)
        else:
            self.speak_and_listen("When would you like to reschedule your checkup?")
            new_time = await self._wait_for_response()
            # Parse new time and update if valid
            try:
                response = requests.post(
                    f"{self.backend_url}/checkup/select-time/",
                    json={
                        "checkup_id": checkup_id,
                        "selected_time": new_time
                    }
                )
                if response.status_code == 200:
                    self.speak(f"Your checkup has been rescheduled to {new_time}")
                else:
                    self.speak("I'm sorry, that time is not within your appointment range.")
            except Exception as e:
                print(f"Error rescheduling checkup: {e}")
                self.speak("I'm sorry, there was an error rescheduling your checkup.")

    async def _conduct_checkup(self, checkup_id: str):
        """Conduct the actual checkup process"""
        try:            
            checkup = response.json()
            questions = json.loads(checkup['questions'])
            responses = {}
            temperature = None
            photo_data = None

            # Take temperature if required
            if checkup.get('measure_temperature', False):
                self.speak("I will now take your temperature. Please stay still.")
                temperature = await self._take_temperature()
                if temperature:
                    self.speak(f"Your temperature is {temperature:.1f} degrees Celsius.")
                else:
                    self.speak("I'm sorry, I couldn't get a proper temperature reading.")

            # Take photo if required
            if checkup.get('take_photo', False):
                self.speak("I will now take your photo. Please look at me and smile.")
                photo_data = await self._take_photo()
                if photo_data:
                    self.speak("Photo taken successfully.")
                else:
                    self.speak("I'm sorry, I couldn't take your photo properly.")

            # Ask questions
            for question in questions:
                self.speak_and_listen(question)
                response = await self._wait_for_response()
                responses[question] = response

            # Submit checkup responses
            response_data = {
                "checkup": checkup_id,
                "responses": json.dumps(responses),
                "temperature": temperature,
                "photo_data": photo_data
            }

            submit_response = requests.post(
                f"{self.backend_url}/checkup/response/",
                json=response_data
            )

            if submit_response.status_code == 201:
                self.speak("Your checkup is complete. The results have been sent to your caregiver.")
            else:
                self.speak("I'm sorry, there was an error saving your checkup results.")

        except Exception as e:
            print(f"Error conducting checkup: {e}")
            self.speak("I'm sorry, there was an error during your checkup.")

    async def _take_temperature(self) -> Optional[float]:
        """Take temperature reading from the patient"""
        try:
            # Configure temperature measurement
            response = self.misty.get_subject_temperature(
                calROILeft=100,  # Calibration region of interest
                calROIWidth=100,
                calROITop=100,
                calROIHeight=100,
                subjectROILeft=200,  # Subject region of interest
                subjectROIWidth=200,
                subjectROITop=200,
                subjectROIHeight=200,
                calTemperature=25.0  # Calibration temperature
            )
            
            if response.status_code == 200:
                data = response.json()
                return data.get('temperature', None)
            return None
        except Exception as e:
            print(f"Error taking temperature: {e}")
            return None

    async def _take_photo(self) -> Optional[str]:
        """Take a photo of the patient"""
        try:
            response = self.misty.take_picture(
                base64=True,
                fileName="patient_photo.jpg",
                width=640,
                height=480,
                displayOnScreen=True,
                overwriteExisting=True
            )
            
            if response.status_code == 200:
                data = response.json()
                return data.get('base64', None)
            return None
        except Exception as e:
            print(f"Error taking photo: {e}")
            return None

    def _temperature_reading(self, data):
        """Handle temperature reading events"""
        if data["message"]["type"] == "temperature":
            self.temperature_reading = data["message"]["temperature"]

    def _photo_taken(self, data):
        """Handle photo taken events"""
        if data["message"]["type"] == "photo":
            self.photo_data = data["message"]["base64"]

    async def _wait_for_response(self) -> str:
        """Wait for and process patient's response"""
        self.response_received.clear()
        self.current_response = None
        
        # Start listening for speech
        self.listen()
        
        # Wait for response with timeout
        try:
            await asyncio.wait_for(self.response_received.wait(), timeout=30)
        except asyncio.TimeoutError:
            return ""
        
        return self.current_response

    def _speech_captured(self, data):
        """Handle speech recognition events"""
        if data["message"]["step"] == "CompletedASR":
            self.current_response = data["message"]["text"]
            self.response_received.set()

    def _audio_play_complete(self, data):
        """Handle audio playback completion"""
        self.audio_finished = True

    def speak_and_listen(self, text: str):
        """Speak text and listen for response"""
        audio_content = text_to_speech(text)
        self.misty.save_audio(fileName="output.mp3", data=audio_content, immediatelyApply=False, overwriteExisting=True)
        self.misty.play_and_listen(audioFile="output.mp3")

    def speak(self, text: str):
        """Just speak text"""
        audio_content = text_to_speech(text)
        self.misty.save_audio(fileName="output.mp3", data=audio_content, immediatelyApply=True, overwriteExisting=True)

    def listen(self):
        """Just listen"""
        print("Listening...")
        self.misty.play_and_listen(audioFile='silent_audio.wav')

async def run_checkup_process(checkin: VirtualCheckIn):
    """Run the checkup process continuously"""
    while True:
        try:
            print(f"[{datetime.now()}] Checking for due checkups...")
            due_checkups = await checkin.get_due_checkups()
            
            if due_checkups:
                print(f"Found {len(due_checkups)} due checkups")
                for checkup in due_checkups:
                    print(f"Processing checkup for patient")
                    await checkin.start_checkup(checkup['id'])
            else:
                print("No checkups due at this time")
            
            # Wait before next poll
            await asyncio.sleep(CHECKUP_POLL_INTERVAL)
            
        except Exception as e:
            print(f"Error in checkup process: {e}")
            # Wait a bit before retrying
            await asyncio.sleep(60)

async def main():
    try:
        # Initialize Misty robot
        print(f"Connecting to Misty at {MISTY_IP}...")
        misty = Robot(MISTY_IP)
        
        # Initialize VirtualCheckIn with backend URL
        print(f"Initializing VirtualCheckIn with backend at {BACKEND_URL}...")
        checkin = VirtualCheckIn(misty, BACKEND_URL)
        
        # Start the continuous checkup process
        print("Starting checkup process...")
        await run_checkup_process(checkin)
        
    except Exception as e:
        print(f"Fatal error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    asyncio.run(main())