#!/usr/bin/env python3
import board
import neopixel
import sys
import colorsys

LED_PIN = board.D18
ORDER   = neopixel.GRB

def set_color(r: int, g: int, b: int):
    pixels = neopixel.NeoPixel(
        LED_PIN,
        1,
        brightness=0.2,
        auto_write=False,
        pixel_order=ORDER
    )

    pixels[0] = (r, g, b)
    pixels.show()
    
if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: set_led.py R G B")
        sys.exit(1)

    r, g, b = map(int, sys.argv[1:4])
    set_color(r, g, b)

