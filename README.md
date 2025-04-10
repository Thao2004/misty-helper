# Misty Care: A Robot Caregiver for the Elderly

## What It Does
As students passionate about using technology for social good, we wanted to create something meaningful for our aging population. Elderly people often live alone and face challenges with medication adherence, health monitoring, and social isolation. Inspired by the idea of a robot caregiver, we set out to build a supportive companion using Misty the robot, capable of interacting with seniors through voice, detecting falls, and ensuring medication plans are followed correctly.

## What We Built
We developed a system that integrates an iOS caregiver app, a Django backend, and Misty the robot. Our solution includes:

### **Caregiver iOS App**
- Caregivers can schedule checkups, create custom questions, and assign medication plans with dosage, frequency, and timing.

### **Misty's Daily Tasks**
- Conduct checkups using voice-based questions and temperature readings.
- Remind patients about medication intake.
- Take photos when the patient shows their medication, send the image to Roboflow, and validate if the correct drug is being taken.
- Conduct meditation sessions upon request.

### **Backend**
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

## What We Learned
- How to program Misty's SDK for speech, emotion display, and interactive control.
- How to use Gemini / LLM APIs for handling natural conversations and responses.
- How to integrate Roboflow for real-time drug recognition using computer vision and COCO annotations.
- Building a full-stack system connecting iOS, Django, and hardware in real-time.
- Designing systems that prioritize accessibility and empathy.

---

## How We Built It
- **Frontend**: Swift iOS app for caregivers to manage plans and checkups and patients to view their info and see their checkups.
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

## Link to Our Demo Videos
[Demo Videos](https://drive.google.com/drive/folders/1ZY48Qaq21S-a7W4wtOGreNQ9_OP9RnAC?usp=drive_link)

---

## Built With
- **Computer Vision**
- **Django**
- **Misty SDK**
- **Swift**
