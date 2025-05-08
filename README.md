# Misty Care: A Robot Caregiver for the Elderly

## What It Does
As students passionate about using technology for social good, we wanted to create something meaningful for our aging population. Elderly people often live alone and face challenges with medication adherence, health monitoring, and social isolation. Inspired by the idea of a robot caregiver, we set out to build a supportive companion using Misty the robot, capable of interacting with seniors through voice, detecting falls, and ensuring medication plans are followed correctly.

## What We Built
We developed a system that integrates an iOS caregiver app, a Django backend, and Misty the robot. Our solution includes:

### 📱 Misty Care iOS App (Two Portals)

The Misty Care mobile app includes both caregiver and patient portals:

- **Caregiver Portal**:  
  Caregivers can schedule checkups, create custom questions, and assign medication plans with dosage, frequency, and timing.

- **Patient Portal**:  
  Patients can connect to Misty, view checkup history, see their caregiver-assigned medication list, and track upcoming scheduled checkups.


### 🤖 **Misty's Daily Tasks**
- Conduct checkups using voice-based questions and temperature readings.
- Remind patients about medication intake.
- Take photos when the patient shows their medication, send the image to Roboflow, and validate if the correct drug is being taken.
- Conduct meditation sessions upon request.

### 🖥️ **Backend**
- A centralized Django server that connects Misty, the app, and stores patient data.

---

## How to Set Up the Project

### 1. Create a Virtual Environment
```bash
python3 -m venv env
```

### 2. Activate the Virtual Environment
```bash
source env/bin/activate  # Linux/macOS
.\env\Scripts\activate   # Windows
```

### 3. Install Required Packages
```bash
pip install -r requirements.txt
```

### 4. Run the Backend Server
```bash
cd misty_backend
python manage.py migrate
python manage.py runserver
```

---

## How to Run the iOS App

To simulate real-world usage, you can interact with the backend using the Misty Care iOS app built in Swift.

### Prerequisites
- macOS with Xcode installed (tested with version XX+)
- iOS Simulator (tested on iPhone 16 Pro)
- Backend server running (see setup instructions above)

### Setup Steps
### 1. Clone the Repository
```
git clone https://github.com/your-username/misty-helper.git
cd misty-helper/MistyiOS
```

### 2. Open in Xcode
- Double-click MistyiOSApp.xcodeproj (or open it from Xcode)
- Wait for dependencies to resolve if prompted

### 3. Run on Simulator
- In Xcode, select a device such as iPhone 16 Pro
- Click the ▶️ Run button or press Cmd + R

### 4. Ensure the Backend is Running
- Make sure the Django backend is live at http://127.0.0.1:8000
- You can confirm this by visiting that URL in your browser or making a test request

### 5. Test Interaction**
- Upon launching the app, you'll be prompted to **sign in**.
- You can use the following **sample test credentials** to log in:

     **Caregiver Login**
     - Username: `william710`
     - Password: `secret123`

     **Patient Login**
     - Username: `patient1`
     - Password: `secret123`

- Alternatively, you can create a new caregiver or patient account from within the app.
- All account and interaction data will be recorded and stored in the Django backend.

- After logging in, you can:
    - Schedule checkups and medications
    - Interact with Misty and receive updates in real-time


### Note:
- If you're running the backend on a different machine or port, make sure to update the base URL in the Swift files (e.g., ConnectToMistyView.swift or PatientDashboardViewModel.swift)
  
---

## 🧪 Testing Without the Misty Robot

While Misty is a key part of our vision, we understand not everyone has access to a Misty II robot. You can still experience and test the full functionality of the caregiver and patient portals through the iOS app and Django backend alone.

- The backend will store all caregiver/patient data and simulate responses.
- The iOS app remains fully interactive for scheduling, checkups, and reviewing data.
- Demo videos are provided above to showcase Misty's interactions for users who do not have the hardware.

This makes the project accessible and testable for recruiters, developers, and collaborators alike.

---

## What We Learned
- How to program Misty's SDK for speech, emotion display, and interactive control.
- How to use Gemini / LLM APIs for handling natural conversations and responses.
- How to integrate Roboflow for real-time drug recognition using computer vision and COCO annotations.
- Building a full-stack system connecting iOS, Django, and hardware in real-time.
- Designing systems that prioritize accessibility and empathy.

---

## How We Built It
- **Frontend**: A Swift-based iOS app that provides two distinct portals:
  - **Caregiver Portal**: Allows caregivers to create and manage patient profiles, schedule medication plans, assign voice-based checkup questions, and monitor patient history and adherence.
  - **Patient Portal**: Enables patients to connect to Misty, view their personalized medication lists, track upcoming checkups, and review completed health assessments. The interface is designed to be simple and accessible, especially for elderly users.
- **Backend**: Django with RESTful APIs for patient/caregiver management and Misty integration.
- **Misty SDK**: Custom functions for talking, displaying emotions, responding to commands, and capturing images.
- **Roboflow**: Trained a model to detect 5 medication types using COCO-format data and integrated it with Misty’s photo-check feature.
- **Voice Interaction**: Used Gemini to help Misty hold simple and kind conversations.

---

## Challenges We Ran Into
- Misty SDK had limited documentation and needed creative workarounds for some features.
- Real-time image prediction with Roboflow required syncing image capture, upload, and response analysis.
- Coordinating communication between the iOS app, Django backend, and Misty robot reliably.
- Designing a conversation flow that felt natural and reassuring for elderly users.
- Time constraints at the hackathon – so many ideas, so little time!

---

## What's Next
- Add facial recognition so Misty can greet users by name.
- Expand medication detection with more drug types and pills in different lighting conditions.
- Improve Misty’s conversational memory to support more dynamic and personalized interactions.

---

##  🎥 Link to Our Demo Videos
- [Misty performing a checkup](https://drive.google.com/drive/folders/10MmPA0XU8FWHhh6FzXD4D0afz2J4Ix7K?usp=drive_link)
- [Patient sign up and log in walkthrough](https://drive.google.com/file/d/1RTBIV3EoKEoXKTrHk8Htbbg4GCylylwA/view?usp=drive_link)
- [Patient Portal](https://drive.google.com/file/d/1RTBIV3EoKEoXKTrHk8Htbbg4GCylylwA/view?usp=drive_link)
- [Caregiver Portal](https://drive.google.com/file/d/1O-ijz2vKO95fnY1hJ-7vpWpzFMrwJmt8/view?usp=drive_link)
- [Medication verification with Roboflow](https://drive.google.com/drive/folders/1BY9L0hNH9WOm2BeonJYSy2k1GZGEeQmH?usp=drive_link)

---

## Built With
- **Computer Vision**
- **Django**
- **Misty SDK**
- **Swift**
