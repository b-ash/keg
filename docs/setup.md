## Setting up the goods

### Project schema

I stumbled on the [Carriots tutorial](https://www.carriots.com/tutorials/Arduino_RPi_Carriots/flowmeter#arduino_raspberry) on how to set things up to a flow meter. This tutorial was exactly how we went about hooking up the raspberry pi, arduino, and flow meter. As far as some legistics:

- We placed the breadboard at the top right corner of the inside of the fridge. This allows us to place the temperature sensor inside the fridge, and have a location to attach the flow meter to.
- We soldered 3 wire from the inputs to the flow meter in order to extend the cables to reach the breadboard in the back.
- Wires from the breadboard are fed out of the fridge through hole with the CO2 tubing in the back.
- The Arduino and RaspberryPi are placed in a project enclosure on top of the keg, right by the tablet we use to display the stats.

### Webservice and UI

The webservice uses Node.js and stores posts made by the raspberry pi. It also uses SockJS to interface with the UI for things like alerting when a pour is happening, updating the temperature, etc. Our setup uses nginx to serve the UI and rewrite the api to the node process. Use whatever you like that will fit your needs :palm_tree:

Subsequently, the URL path the RaspPi will depend on where the webservice is hosted.
