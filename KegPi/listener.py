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
    # resp = requests.post(api_url, data=json.dumps(data))
    # print resp.status_text
    # return resp
    print json.dumps(data)

while True:
    line = input.readline().strip()

    if line:
        print line

        action, output = line.split(':')

        if action == 'pulses':
            pulses = int(output.strip())
            ounces = float(pulses) / 175
            data = {'ounces': ounces}
            print "Ounces: %i" % ounces
        elif action == 'temp':
            data = {'temp': output.strip()}

        send(data)
