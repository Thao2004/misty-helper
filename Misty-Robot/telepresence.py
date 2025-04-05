import asyncio
import json
import logging
from aiortc import RTCPeerConnection, RTCSessionDescription, VideoStreamTrack
from aiortc.contrib.media import MediaPlayer, MediaRecorder
from mistyPy.Robot import Robot
import cv2
import numpy as np
import websockets
import threading
import time

class MistyTelepresence:
    def __init__(self, robot_ip):
        self.misty = Robot(robot_ip)
        self.pc = RTCPeerConnection()
        self.video_track = None
        self.audio_track = None
        self.remote_video_track = None
        self.remote_audio_track = None
        self.websocket = None
        self.is_running = False
        
        # Set up logging
        logging.basicConfig(level=logging.INFO)
        self.logger = logging.getLogger("MistyTelepresence")

    async def start_camera(self):
        """Start Misty's camera and create video track"""
        # Start AV streaming
        self.misty.start_av_streaming()
        self.video_track = MistyVideoTrack(self.misty)
        self.pc.addTrack(self.video_track)

    async def start_audio(self):
        """Start Misty's audio capture and create audio track"""
        # Audio is handled by start_av_streaming()
        self.audio_track = MistyAudioTrack(self.misty)
        self.pc.addTrack(self.audio_track)

    async def display_web_view(self, url):
        """Display web content on Misty's screen"""
        self.misty.DisplayWebView(url)

    async def connect_to_signaling_server(self, signaling_server_url):
        """Connect to WebRTC signaling server"""
        self.websocket = await websockets.connect(signaling_server_url)
        self.is_running = True
        
        # Start listening for messages
        asyncio.create_task(self._handle_signaling_messages())

    async def _handle_signaling_messages(self):
        """Handle incoming WebRTC signaling messages"""
        while self.is_running:
            try:
                message = await self.websocket.recv()
                data = json.loads(message)
                
                if data["type"] == "offer":
                    await self._handle_offer(data)
                elif data["type"] == "answer":
                    await self._handle_answer(data)
                elif data["type"] == "candidate":
                    await self._handle_candidate(data)
            except websockets.exceptions.ConnectionClosed:
                self.logger.error("Signaling connection closed")
                break

    async def _handle_offer(self, data):
        """Handle incoming offer"""
        offer = RTCSessionDescription(sdp=data["sdp"], type=data["type"])
        await self.pc.setRemoteDescription(offer)
        
        # Create and send answer
        answer = await self.pc.createAnswer()
        await self.pc.setLocalDescription(answer)
        await self.websocket.send(json.dumps({
            "type": "answer",
            "sdp": self.pc.localDescription.sdp
        }))

    async def _handle_answer(self, data):
        """Handle incoming answer"""
        answer = RTCSessionDescription(sdp=data["sdp"], type=data["type"])
        await self.pc.setRemoteDescription(answer)

    async def _handle_candidate(self, data):
        """Handle incoming ICE candidate"""
        candidate = data["candidate"]
        await self.pc.addIceCandidate(candidate)

    def display_remote_video(self, frame):
        """Display remote video on Misty's screen"""
        # Convert frame to appropriate format for Misty's display
        # This is a placeholder - actual implementation will depend on Misty's display API
        self.misty.display_image(frame)

    def stop(self):
        """Stop all telepresence activities"""
        self.is_running = False
        if self.websocket:
            asyncio.create_task(self.websocket.close())
        self.misty.stop_av_streaming()
        self.pc.close()

class MistyVideoTrack(VideoStreamTrack):
    def __init__(self, misty):
        super().__init__()
        self.misty = misty
        self.frame = None
        self.lock = threading.Lock()

    async def recv(self):
        """Get next video frame from Misty's camera"""
        with self.lock:
            # Get frame from Misty's camera through AV streaming
            frame = self.misty.get_av_streaming_frame()
            if frame is not None:
                self.frame = frame
            return self.frame

class MistyAudioTrack:
    def __init__(self, misty):
        self.misty = misty
        self.audio_data = None
        self.lock = threading.Lock()

    async def recv(self):
        """Get next audio frame from Misty's microphone"""
        with self.lock:
            # Get audio from Misty's microphone through AV streaming
            audio = self.misty.get_av_streaming_audio()
            if audio is not None:
                self.audio_data = audio
            return self.audio_data

async def main():
    # Initialize telepresence
    telepresence = MistyTelepresence("YOUR_MISTY_IP")
    
    try:
        # Start camera and audio
        await telepresence.start_camera()
        await telepresence.start_audio()
        
        # Display web interface on Misty's screen
        await telepresence.display_web_view("http://localhost:8000")
        
        # Connect to signaling server
        await telepresence.connect_to_signaling_server("ws://your-signaling-server:port")
        
        # Keep the connection alive
        while telepresence.is_running:
            await asyncio.sleep(1)
            
    except Exception as e:
        logging.error(f"Error in telepresence: {e}")
    finally:
        telepresence.stop()

if __name__ == "__main__":
    asyncio.run(main()) 