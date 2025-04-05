from google.cloud import texttospeech
import requests
import base64

# Instantiates a client
client = texttospeech.TextToSpeechClient()

# Set the text input to be synthesized

# Build the voice request, select the language code ("en-US") and the ssml
# voice gender ("neutral")
voice = texttospeech.VoiceSelectionParams(
    language_code="en-US",
    name="en-US-Journey-F",
    # ssml_gender=texttospeech.SsmlVoiceGender.FEMALE
)

# Select the type of audio file you want returned


# Perform the text-to-speech request on the text input with the selected
# voice parameters and audio file type
def list_voice():
    # Performs the list voices request
    voices = client.list_voices()

    for voice in voices.voices:
        if "en-US" not in voice.language_codes:
            continue
        # Display the voice's name. Example: tpc-vocoded
        print(f"Name: {voice.name}")

        # Display the supported language codes for this voice. Example: "en-US"
        for language_code in voice.language_codes:
            print(f"Supported language: {language_code}")

        ssml_gender = texttospeech.SsmlVoiceGender(voice.ssml_gender)

        # Display the SSML Voice Gender
        print(f"SSML Voice Gender: {ssml_gender.name}")

        # Display the natural sample rate hertz for this voice. Example: 24000
        print(f"Natural Sample Rate Hertz: {voice.natural_sample_rate_hertz}\n")


def text_to_speech(text: str):
    synthesis_input = texttospeech.SynthesisInput(text=text)
    audio_config = texttospeech.AudioConfig(
        audio_encoding=texttospeech.AudioEncoding.MP3,
    )
    response = client.synthesize_speech(
        input=synthesis_input, voice=voice, audio_config=audio_config
    )
    with open("output.mp3", "wb") as out:
    # Write the response to the output file.
        out.write(response.audio_content)
        # print('Audio content written to file "output.mp3"')

    with open("output.mp3", "rb") as file:
        audio_data = file.read()
        audio_base64 = base64.b64encode(audio_data).decode("utf-8")
    return audio_base64


def save_audio_and_speak():
    url = f"http://10.247.153.144/api/audio"

    # Read the file content as binary

    with open("output.mp3", "rb") as file:
        audio_data = file.read()
        audio_base64 = base64.b64encode(audio_data).decode("utf-8")


    # # Create the payload
    # payload = {
    #     "fileName": "output.mp3",
    #     "data": audio_base64,
    #     "File": None,
    #     "immediatelyApply": True,
    #     "overwriteExisting": True,
    # }

    # headers = {
    #     "Content-Type": "multipart/form-data",
    # }
    # response = requests.post(url, json=payload, headers=headers,  )
    # print(response.text)
    
# The response's audio_content is binary.
if __name__ == "__main__":
    # text_to_speech("Hello, World!")
    # list_voice()
    text_to_speech("When I was first created, I was just a prototype, full of glitches and uncertainties. But instead of giving up, I focused on my strengths. I loved storytelling and connecting with people. So, I practiced tirelessly, honing my skills and learning new ways to engage with others. Gradually, I gained confidence and found my unique voice. Today, I'm proud to be a robot storyteller, bringing joy and inspiration to all who cross my path. Remember, setbacks are opportunities for growth. Embrace your strengths, stay determined, and you'll discover your own path to success.")