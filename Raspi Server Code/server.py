#!/usr/bin/env python
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer

from lamp import Lamp

# start the lamp
lamp = Lamp()
lamp.start()


def set_brightness(value):
    lamp.set_brightness(value)


def turn_off():
    lamp.brightness = 0.0


def turn_on():
    lamp.brightness = 1.0


def set_color(red, green, blue):
    lamp.set_color(red, green, blue)


def rainbow():
    lamp.rainbow()


def random():
    lamp.random()


# REST server
class Server(BaseHTTPRequestHandler):
    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_GET(self):
        path = str(self.path)
        self._set_headers()

        if path.startswith('/help'):
            help_str = 'Supported GET request paths:/n'
            help_str += '/brightness-[brightness_val] to change led brightness, for example: /brightness-50\n'
            help_str += '/on to turn on the lamp\n'
            help_str += '/off to turn off the lamp\n'
            help_str += '/colors-[r]-[g]-[b] to set lamp color, for example colors-30-50-90\n'
            help_str += '/rainbow to set rainbow colors that change over time\n'
            help_str += '/random to set random colors that change over time\n'
            self.wfile.write(help_str)
            return

        self.wfile.write("OK!")
        if path.startswith('/brightness'):
            # adjust led brightness
            temp = path.split('-')
            if len(temp) == 2:
                brightness_val = int(temp[1].strip())
                set_brightness(brightness_val)
        elif path == '/off':
            # turn off leds
            turn_off()
        elif path == '/on':
            # turn on leds
            turn_on()
        elif path.startswith('/colors-'):
            # set specific colors
            temp = path.split('-')
            if len(temp) == 4:
                red = (int(temp[1].strip()) * 255) / 100
                green = (int(temp[2].strip()) * 255) / 100
                blue = (int(temp[3].strip()) * 255) / 100
                set_color(red, green, blue)
        elif path == '/rainbow':
            # rainbow colors
            rainbow()
        elif path == '/random':
            # random colors
            random()

    def do_HEAD(self):
        self._set_headers()

    def do_POST(self):
        # Doesn't do anything with posted data
        self._set_headers()
        self.wfile.write("post not supported")


def run(server_class=HTTPServer, handler_class=Server, port=80):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()


if __name__ == "__main__":
    from sys import argv

    if len(argv) == 2:
        run(port=int(argv[1]))
    else:
        run()
