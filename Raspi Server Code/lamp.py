#!/usr/bin/python
import random
import threading
import time

from neopixel import *

# modified from https://github.com/jgarff/rpi_ws281x

LED_COUNT = 16  # Number of LED pixels.
LED_PIN = 18  # GPIO pin connected to the pixels (must support PWM!).
LED_FREQ_HZ = 800000  # LED signal frequency in hertz (usually 800khz)
LED_DMA = 5  # DMA channel to use for generating signal (try 5)
LED_INVERT = False  # True to invert the signal (when using NPN transistor level shift)


class LEDColor:
    def __init__(self, r, g, b):
        self.red = r
        self.green = g
        self.blue = b

    def get_color(self, brightness):
        return Color((self.green * brightness) / 100, (self.red * brightness) / 100, (self.blue * brightness) / 100)


class Lamp(threading.Thread):

    def run(self):
        rainbow_i = 0
        while True:
            if self.state == 'random':
                self.set_random_colors()
            elif self.state == 'rainbow':
                rainbow_i = (rainbow_i + 1) % 255
                self.set_rainbow_colors(rainbow_i)
            else:
                self.__write_to_strip()
                time.sleep(0.1)

    def __init__(self):
        super(Lamp, self).__init__()
        self.brightness = 50
        self.strip = Adafruit_NeoPixel(LED_COUNT, LED_PIN, LED_FREQ_HZ, LED_DMA, LED_INVERT)
        self.strip.begin()
        self.colors = []
        self.state = 'None'

    def set_brightness(self, value):
        self.brightness = value
        self.__write_to_strip()

    @staticmethod
    def __get_random_color():
        while True:
            r = random.randint(0, 256)
            g = random.randint(0, 256)
            b = random.randint(0, 256)
            # we want the colors to be saturated so only return colors that have at least one "bright" component
            if r > 200 or g > 200 or b > 200:
                return LEDColor(r, g, b)

    def random(self):
        self.state = 'random'

    # set each led to a random color
    def set_random_colors(self):
        self.colors = []
        for i in range(LED_COUNT):
            rand_color = self.__get_random_color()
            self.colors.append(rand_color)
        self.__write_to_strip()
        time.sleep(1)

    def __wheel(self, pos):
        if pos < 85:
            return LEDColor(pos * 3, 255 - pos * 3, 0)
        elif pos < 170:
            pos -= 85
            return LEDColor(255 - pos * 3, 0, pos * 3)
        else:
            pos -= 170
            return LEDColor(0, pos * 3, 255 - pos * 3)

    def chase_rainbow(self, i, wait_ms=50):
        self.colors = []
        for j in range(0, LED_COUNT):
            jump = 256/LED_COUNT * j
            self.colors.append(self.__wheel((i + jump) % 255))
        self.__write_to_strip()
        time.sleep(wait_ms / 1000.0)

    def rainbow(self):
        self.state = 'rainbow'

    # set rainbow colors that all change over time
    def set_rainbow_colors(self, j, wait_ms=25):
        self.colors = []
        for i in range(self.strip.numPixels()):
            self.colors.append(self.__wheel((i + j) & 255))
        self.__write_to_strip()
        time.sleep(wait_ms / 1000.0)

    # set a specific color in rgb values
    def set_color(self, r, g, b):
        self.state = 'None'
        self.colors = []
        color = LEDColor(r, g, b)
        for i in range(LED_COUNT):
            self.colors.append(color)

    # write the color to the strip
    def __write_to_strip(self):
        if len(self.colors) < LED_COUNT:
            return
        for i in range(LED_COUNT):
            self.strip.setPixelColor(i, self.colors[i].get_color(self.brightness))
        self.strip.show()
