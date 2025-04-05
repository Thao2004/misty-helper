from http.server import HTTPServer, SimpleHTTPRequestHandler
import os
import logging

class WebHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=os.path.dirname(os.path.abspath(__file__)), **kwargs)

    def do_GET(self):
        if self.path == '/':
            self.path = '/web_interface.html'
        return super().do_GET()

def run_web_server(port=8000):
    logging.basicConfig(level=logging.INFO)
    server_address = ('', port)
    httpd = HTTPServer(server_address, WebHandler)
    logging.info(f"Web server started on http://localhost:{port}")
    httpd.serve_forever()

if __name__ == "__main__":
    run_web_server() 