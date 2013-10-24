## Raspberry Pi setup

Engadget wrote [a fabulous article](http://www.engadget.com/2012/09/04/raspberry-pi-getting-started-guide-how-to/) on how to get started with the Pi. We followed this pretty closely. Take a quick read over it before really digging in.

### OS choices

When we installed Raspbian, we got the OS from [the raspberry pi downloads page](http://www.raspberrypi.org/downloads). By using the NOOBS (v1.3 at the time) setup, we only had to do a few steps:

- Format the SD card using the disk formatter utility available on that downloads page
- Copy the NOOBS build onto it
- Put the SD card in the pi

### Working with WiFi

After following the steps on the raspbian setup wizard, I also used [another article](http://www.howtogeek.com/167425/how-to-setup-wi-fi-on-your-raspberry-pi-via-the-command-line/) to get the WiFi dongle working. Both steps were pretty straight forward.

### Next steps

At this point, this should give you a working linux machine OS the RaspPi. I use cloud hosting to host the webservice, MySQL DB, and UI, although you could use the Raspberry Pi to do those things as well. Some quick googling should show how to do those things :smiley_cat:
