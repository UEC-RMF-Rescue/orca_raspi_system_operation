#!/usr/bin/env python3
import board
import neopixel
import sys
import colorsys

LED_PIN = board.D18
ORDER   = neopixel.GRB

def hsv_to_rgb(h, s, v):
    r, g, b = colorsys.hsv_to_rgb(h, s, v)
    return int(r * 255), int(g * 255), int(b * 255)

def set_color(r: int, g: int, b: int):
    pixels = neopixel.NeoPixel(
        LED_PIN,
        1,
        brightness=0.2,
        auto_write=False,
        pixel_order=ORDER
    )

    if r > 255:
        hue = 0.0
        while True:
            rgb = hsv_to_rgb(hue, 1.0, 1.0)
            pixels[0] = rgb
            pixels.show()

            hue += 0.0002  # 色相を少しずつずらす
            if hue > 1.0:
                hue = 0.0

        time.sleep(0.5)

    else:
        pixels[0] = (r, g, b)
        pixels.show()
    
if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: set_led.py R G B")
        sys.exit(1)

    r, g, b = map(int, sys.argv[1:4])
    set_color(r, g, b)

