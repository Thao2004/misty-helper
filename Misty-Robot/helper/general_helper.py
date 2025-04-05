import requests
from mistyPy.Robot import Robot
from mistyPy.Events import Events
import queue
import threading
import json

# Imports the Google Cloud client library


from google.cloud import speech
def transcribe_streaming(stream_file: str) -> speech.RecognitionConfig:
    """Streams transcription of the given audio file."""

    client = speech.SpeechClient()

    with open(stream_file, "rb") as audio_file:
        content = audio_file.read()

    # In practice, stream should be a generator yielding chunks of audio data.
    stream = [content]

    requests = (
        speech.StreamingRecognizeRequest(audio_content=chunk) for chunk in stream
    )

    config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
        sample_rate_hertz=16000,
        language_code="en-US",
    )

    streaming_config = speech.StreamingRecognitionConfig(config=config)

    # streaming_recognize returns a generator.
    responses = client.streaming_recognize(
        config=streaming_config,
        requests=requests,
    )

    for response in responses:
        # Once the transcription has settled, the first result will contain the
        # is_final result. The other results will be for subsequent portions of
        # the audio.
        for result in response.results:
            print(f"Finished: {result.is_final}")
            print(f"Stability: {result.stability}")
            alternatives = result.alternatives
            # The alternatives are ordered from most likely to least.
            for alternative in alternatives:
                print(f"Confidence: {alternative.confidence}")
                print(f"Transcript: {alternative.transcript}")

import argparse

from google.cloud import speech


def transcribe_audio_file(speech_file: str) -> speech.RecognizeResponse:
    """Transcribe the given audio file."""
    client = speech.SpeechClient()

    with open(speech_file, "rb") as audio_file:
        content = audio_file.read()
    audio = speech.RecognitionAudio(content=content)
    config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
        sample_rate_hertz=16000,
        language_code="en-US",
    )

    response = client.recognize(config=config, audio=audio)

    # Each result is for a consecutive portion of the audio. Iterate through
    # them to get the transcripts for the entire audio file.
    # print(response.results)
    if len (response.results) == 0:
        return ""
    for result in response.results:
        # The first alternative is the most likely one for this portion.
        print(f"Transcript: {result.alternatives[0].transcript}")
    
    return result.alternatives[0].transcript
   

# def response_from_llama_generate(prompt):
    # url = "http://localhost:11434/api/generate"
    # # Define the request payload
    # payload = {
    #     "model": "llama2",
    #     "prompt": prompt,
    # }
    # # Send the POST request
    # response = requests.post(url, json=payload, stream=True)
    # temp = ""
    # if response.status_code == 200:
    # # Iterate over the response content as it arrives
    #     for chunk in response.iter_content(chunk_size=1024):
    #         if chunk:
    #             response_data = json.loads(chunk.decode())
    #             if response_data["done"] == False:
    #                 if response_data["response"][0] != "." and response_data["response"][0] != ",":
    #                     temp += response_data["response"]
    #                 else:
    #                     temp += response_data["response"]
    #                     print(temp)
    #                     misty.speak(temp)
    #                     temp = ""
    #             else:
    #                 break
        
    #     time.sleep(3)
    #     print("---------")
    #     capture_speech()
    # else:
    #     print("Error:", response.text)
    #     misty.speak("Sorry. My story telling module is not working at the moment. Please try again later.")

