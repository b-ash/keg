## Keg.bry.io

Keg stats and information for project Codename: Kegums.

The hardware design is heavily influenced by the awesome guys at [KegBot.org](https://kegbot.org/).

### Docs

- [Shopping list](docs/shopping.md)
- [Setting up the Arduino](docs/arduino.md)
- [Setting up the Raspberry Pi](docs/pi.md)
- [Hooking it all up](docs/setup.md)

### External Credits

We used a few helpful articles that I want to give a shout-out (relevant links to articles located in the docs). I had no input in their content, but found them super useful while designing this project:

- [Carriots.com](https://www.carriots.com/)
- [Engadget](http://www.engadget.com/)
- [Howtogeek.com](http://www.howtogeek.com/)
- [Forefront.io](http://forefront.io/)

### Running

Webservice
- Spin up mysql locally
- Run `KegService/schema.sql`
- Run `KegService/start.sql` to get some data in there
- cd into `KegService`
- `node server.js`

UI
- Make sure you have [brunch](https://github.com/brunch/brunch) installed
- cd into `KegUI`
- `npm install`
- `brunch watch --server`

If you want to avoid CORS issues, you can run a proxy to hit those two services. Once example is vee.
- cd to the root of this repo
- `sudo vee`
- Navigate to localhost/
