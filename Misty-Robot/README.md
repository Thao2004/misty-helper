# Misty Telepresence

This project enables real-time, two-way video/audio communication through Misty II robot. It allows remote users to see through Misty's camera and communicate with people near the robot.

## Features

- Real-time video streaming from Misty's camera
- Two-way audio communication
- Display of remote user's video on Misty's screen
- Web interface for remote users
- WebRTC-based communication

## Prerequisites

- Misty II robot
- Python 3.7 or higher
- Web browser with WebRTC support (Chrome, Firefox, Safari)
- Network connection between Misty and the remote user

## Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd Misty-Robot
```

2. Install the required dependencies:
```bash
pip install -r requirements.txt
```

3. Update the Misty IP address in `telepresence.py`:
```python
telepresence = MistyTelepresence("YOUR_MISTY_IP")
```

## Usage

1. Start the signaling server:
```bash
python signaling_server.py
```

2. Start the web server:
```bash
python web_server.py
```

3. Start the telepresence system on Misty:
```bash
python telepresence.py
```

4. Open a web browser and navigate to:
```
http://localhost:8000
```

5. Click "Start Call" to initiate the telepresence session.

## Components

- `telepresence.py`: Main telepresence implementation for Misty
- `signaling_server.py`: WebRTC signaling server
- `web_server.py`: Simple web server for the interface
- `web_interface.html`: Web interface for remote users

## Troubleshooting

1. If video/audio doesn't work:
   - Check if Misty's camera and microphone are properly connected
   - Ensure proper network connectivity
   - Check browser permissions for camera and microphone access

2. If connection fails:
   - Verify Misty's IP address is correct
   - Check if the signaling server is running
   - Ensure all required ports are open (8000 for web server, 8765 for signaling)

## Security Notes

- The current implementation uses a simple signaling server without authentication
- For production use, implement proper security measures
- Consider using HTTPS for the web interface
- Add authentication for the signaling server

## License

This project is licensed under the MIT License - see the LICENSE file for details.