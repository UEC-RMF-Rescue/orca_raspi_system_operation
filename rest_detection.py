import RPi.GPIO as GPIO
import time
import subprocess

GPIO.setmode(GPIO.BCM)

REST_PIN = 19

GPIO.setwarnings(False)
GPIO.setup(REST_PIN, GPIO.IN)

def rest_cb(channel):
    print("Reset")
    subprocess.call(["/home/rmfrescue/sys_op/ros_control.sh", "restart"])

GPIO.add_event_detect(REST_PIN, GPIO.FALLING, callback=rest_cb, bouncetime=300)

try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    print("Exiting rest service")
finally:
    GPIO.cleanup()

