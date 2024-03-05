#Connection Machine CM1 cube blinkenlights simulator, by Nicole Roy, 2022
import random
import time

r = "red"

while True:
    panel = random.randint(0,2)
    art = [
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
    ]

    for x in range(0,8):
        for y in range(0,8):
            tf = random.getrandbits(1)
            if tf:
                art[x][y] = r
    if panel == 0:
        display.set_panel('top', art)
    elif panel == 1:
        display.set_panel('left', art)
    elif panel == 2:
        display.set_panel('right', art)
    time.sleep(1/10)