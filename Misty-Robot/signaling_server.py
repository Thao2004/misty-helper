import asyncio
import json
import logging
import websockets
from typing import Dict, Set

class SignalingServer:
    def __init__(self):
        self.connections: Dict[str, Set[websockets.WebSocketServerProtocol]] = {}
        self.logger = logging.getLogger("SignalingServer")

    async def register(self, websocket: websockets.WebSocketServerProtocol, room_id: str):
        """Register a new connection in a room"""
        if room_id not in self.connections:
            self.connections[room_id] = set()
        self.connections[room_id].add(websocket)
        self.logger.info(f"New connection in room {room_id}")

    async def unregister(self, websocket: websockets.WebSocketServerProtocol, room_id: str):
        """Unregister a connection from a room"""
        if room_id in self.connections:
            self.connections[room_id].remove(websocket)
            if not self.connections[room_id]:
                del self.connections[room_id]
            self.logger.info(f"Connection removed from room {room_id}")

    async def broadcast(self, message: str, room_id: str, sender: websockets.WebSocketServerProtocol):
        """Broadcast a message to all connections in a room except the sender"""
        if room_id in self.connections:
            for connection in self.connections[room_id]:
                if connection != sender:
                    try:
                        await connection.send(message)
                    except websockets.exceptions.ConnectionClosed:
                        await self.unregister(connection, room_id)

async def handler(websocket: websockets.WebSocketServerProtocol, path: str):
    """Handle WebSocket connections"""
    server = SignalingServer()
    room_id = path.strip("/")
    
    try:
        # Register the connection
        await server.register(websocket, room_id)
        
        # Handle messages
        async for message in websocket:
            await server.broadcast(message, room_id, websocket)
            
    except websockets.exceptions.ConnectionClosed:
        pass
    finally:
        await server.unregister(websocket, room_id)

async def main():
    # Set up logging
    logging.basicConfig(level=logging.INFO)
    
    # Start the WebSocket server
    async with websockets.serve(handler, "0.0.0.0", 8765):
        logging.info("Signaling server started on ws://0.0.0.0:8765")
        await asyncio.Future()  # run forever

if __name__ == "__main__":
    asyncio.run(main()) 