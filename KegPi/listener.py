#!/usr/bin/env python

#    Kegums
#    Brewed on: October 14, 2013
#    Authored by: Bryan Ash, Tim Hennekey, Trevor Rundell, Marc Neuwirth

import serial
import requests
import json
from time import localtime, strftime

try:
    input = serial.Serial('/dev/ttyACM0', 9600, timeout=1)
except:
    input = serial.Serial('/dev/ttyACM1', 9600, timeout=1)

log = open('listener.log', 'w', 0)


def print_debug(line):
    log.write('[%s] %s\n' % (get_time(), line))


def get_time():
    return strftime("%Y-%m-%d %H:%M:%S", localtime())


def send(data):
    payload = json.dumps(data)
    url = "http://keg.bry.io/api/%s" % data['endpoint']

    print_debug("%s to receive %s" % (url, payload))
    try:
        resp = requests.post(url, data=payload, headers={'content-type': 'application/json'})
        resp.raise_for_status()
    except:
        print_debug('Post failed')


def parse_ounces(output):
    pulses = int(output.strip())
    return float(pulses) / 175


while True:
    line = input.readline().strip()

    if line:
        rawInput = line.split(':')

        if len(rawInput) != 2:
            continue

        action, output = rawInput

        if action == 'pour':
            data = {
                'endpoint': 'pours',
                'volume': parse_ounces(output)
            }
        elif action == 'pour-end':
            data = {
                'endpoint': 'pour-end',
                'volume': parse_ounces(output)
            }
        elif action == 'temp':
            data = {
                'endpoint': 'temps',
                'degrees': output.strip()
            }
        else:
            print_debug("Ignoring unknown action %s" % action)
            continue

        send(data)
