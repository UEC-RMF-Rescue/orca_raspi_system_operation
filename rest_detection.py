import RPi.GPIO as GPIO
import time
import subprocess
import threading

REST_PIN = 19
DOUBLE_CLK_INTERVAL = 0.5
LONG_PRESS_DURATION = 3.0

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(REST_PIN, GPIO.IN)

last_clk_time = 0
timer = None
click_count=0
long_press_detected = False

def handle_clicks():
    global click_count
    if click_count == 1:
        print("Flip")
        subprocess.call(["/home/rmfrescue/sys_op/ros_control.sh", "flip"])
        
    elif click_count == 2:
        print("Reset")
        subprocess.call(["/home/rmfrescue/sys_op/ros_control.sh", "restart"])
    click_count = 0

def rest_pressed(channel):
    global last_clk_time, timer,click_count, pless_time, long_press_detected
    press_time = time.time()
    long_press_detected = False
    
    while GPIO.input(REST_PIN) == GPIO.LOW:
        time.sleep(0.01)
        if time.time() - press_time > LONG_PRESS_DURATION:
            print("Long press detected: Stop")
            subprocess.call(["/home/rmfrescue/sys_op/reboot.sh"])
            return

    if press_time - last_clk_time > DOUBLE_CLK_INTERVAL:
        click_count = 1
        if timer:
            timer.cancel()
        timer = threading.Timer(DOUBLE_CLK_INTERVAL, handle_clicks)
        timer.start()
    else:
        click_count += 1
    last_clk_time = press_time


GPIO.add_event_detect(REST_PIN, GPIO.FALLING, callback=rest_pressed, bouncetime=200)

try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    print("Exiting rest service")

