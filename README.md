## Keg.bry.io

Keg stats and information

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

