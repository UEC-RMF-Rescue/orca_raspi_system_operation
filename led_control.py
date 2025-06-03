import os
import board
import neopixel
import time
import board
import neopixel

# GPIO number
led_pin = board.D18
ORDER = neopixel.GRB

pixels = neopixel.NeoPixel(
        led_pin, 1, brightness=0.2, auto_write=False, pixel_order=ORDER
        )

FIFO_PATH = "/tmp/led_fifo"
if os.path.exists(FIFO_PATH):
    os.remove(FIFO_PATH)
os.mkfifo(FIFO_PATH)

print("LED Deamon running... Waiting for color commands")

try:
    while True:
        with open(FIFO_PATH, "r") as fifo:
            line = fifo.readline().strip()
            if not line:
                continue

            print(f"Received: {line}")
            try:
                pixels = neopixel.NeoPixel(
                        led_pin, 1, brightness=0.2, auto_write=False, pixel_order=ORDER)
                r, g, b = map(int, line.split(","))
                pixels[0] = (r, g, b)
                pixels.show()
                pixels.deinit()
            except Exception as e:
                print(f"Invalid input: {line} ({e})")
except KeyboardInterrupt:
    print("Exiting LED daemon.")
finally:
    pixels.fill((0, 0, 0))
    os.remove(FIFO_PATH)
