#!/usr/bin/env python

#    Kegums
#    Brewed on: October 14, 2013
#    Authored by: Bryan Ash, Tim Hennekey, Trevor Rundell, Marc Neuwirth

import serial
import requests
import json

try:
    input = serial.Serial('/dev/ttyACM0', 9600, timeout=1)
except:
    input = serial.Serial('/dev/ttyACM1', 9600, timeout=1)

pulses = 0
liters = 0
api_url = "/pour"


def send(data):
    resp = requests.post(api_url, data=json.dumps(data))
    print resp.status_text
    return resp

while True:
    line = input.readline().strip()

    if line:
        print line

        [info, output] = line.split(':')
        pulses = int(output.strip())
        ounces = float(pulses) / 175
        print "Ounces: %i" % ounces
        send({
            'ounces': ounces
        })
