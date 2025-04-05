# Misty Storytelling Robot

This project is integration of LLM into Misty Robot to allow it to generate stories from user input (voice). Misty is able to discuss the stories with an aim to help improve user's mental well-being. Misty class is from Misty SDK.


## Prerequisites

Ensure you have the following software installed:
- Python 3.8+
- pip
- [gcloud CLI](https://cloud.google.com/sdk/docs/install)
- Network: If Misty is connected to the lab network (RARE-IoT), make sure your device is also connected to it in order to send requests to Misty (Lab password is in Teams NEC 0115 channel).
- [Misty App](https://docs.mistyrobotics.com/tools-&-apps/mobile/misty-app/) (on your smart phone)
- [Vertex AI Quick Start](https://cloud.google.com/vertex-ai/generative-ai/docs/start/quickstarts/quickstart-multimodal)

## Installation

To install the required packages, run:

```sh
pip install -r requirements.txt
```

## Authentication

Ensure you have the following:

<!-- - **Gemeni API Key**  
    1. You can obtain it in either of the following ways:  
        a. [Create your own](https://aistudio.google.com/app/apikey)  
        b. Go to `main.py` and grab the key from line 19 in the `genai.configure` call  
    2. Add it as an environment variable with the name `API_KEY` -->

- **Set Up Project and Enable API**
    1. Create a new project at https://console.cloud.google.com/welcome and enable billing with free credits
    2. Make sure you're at the project you are using, search for "Cloud Text-to-Speech API" and enable it
    3. Search for "Gemini API" and enable it
    4. Go to [Quick Start](https://cloud.google.com/vertex-ai/generative-ai/docs/start/quickstarts/quickstart-multimodal) and enable Vertex AI by clicking to "Enable the API" button
    5.  Download Google Cloud SDK (based on your computer), extract it and copy it to the root directory (misty-storytelling)

- **Authorize access and perform common setup steps (be sure to choose the project for which you enabled the API)**  

    
    ```sh
    ./google-cloud-sdk/install.sh
    ```  
    If you just want to log in, use:  
    ```sh
    ./google-cloud-sdk/gcloud auth application-default login
    ```  
    If you want to choose a different project, use:  
    ```sh
    ./google-cloud-sdk/gcloud config set project PROJECT_ID
    ```

## Main 
The latest main file is main_latest.py that fixed the bugs of asynchonous emotion and speech. 

In this file, give the right ip_address of currently controlled Misty (find this via [Misty's app](https://docs.mistyrobotics.com/tools-&-apps/mobile/misty-app/)).
```py
 ip_address = "10.247.153.144"
```
Global variables: 
- audio_finished: indicating if Misty is playing audio or not
- system: instructions for LLM
- count: if it's the first request to Gemini
- emotion: dictionary to for emotion abbrev.

DialogAction Event: calls speech_captured() when Misty finishes listening via functions such as speak_and_listen() and listen()

AudioPlayComplete: calls audio_play_complete that will toggle audio_finished variable. 

At the beginning, Misty will start face detection until it finds a face. Then the instructions, depending on the first or third person narrative, will be loaded into system variable. It will start greet and listen to user voice.

When Misty captures speech from user, the speech_captured() is called through DialogAction Event. In this function, user_input is extracted and then feeds into response_from_gemini() if it's not blank.

In response_from_gemini(), if this is the first request to Gemini, the system will be sent. The response from Gemini is received in stream, and it is splitted to be distinguished between emotion and speech blocks. If it's a speech, speak() will be called. speak() basically turns the text to the audio base64 data (thanks to Google TTS) and saves the audio with audio base64 data to Misty local storage, and then plays the audio file immediately with immediatelyApply=True. Coming back to response_from_gemini(), after calling speak() to play the audio for that chunk, it will not move to next chunk with time.sleep() until AudioPlayComplete turns global variable audio_finished to True.  After completing playing all chunks from Gemini response, listen() is called to let user take turn to respond. Here, the speech_captured is called again and starts a new round of the conversation. 

