# mumble-web

Note: This WebRTC branch is not backwards compatible with the current release, i.e. it expects the server/proxy to support WebRTC which neither websockify nor Grumble do. Also note that it requires an extension to the Mumble protocol which has not yet been stabilized and as such may change at any time, so make sure to keep mumble-web and mumble-web-proxy in sync.

mumble-web is an HTML5 [Mumble] client for use in modern browsers.

A live demo is running [here](https://voice.johni0702.de/webrtc/?address=voice.johni0702.de&port=443/demo).

The Mumble protocol uses TCP for control and UDP for voice.
Running in a browser, both are unavailable to this client.
Instead Websockets are used for control and WebRTC is used for voice.

Therefore, only the Opus codec is supported.

Quite a few features, most noticeably all
administrative functionallity, are still missing.

### Installing

#### Download
mumble-web can either be installed directly from npm with `npm install -g mumble-web`
or from git (webrtc branch only from git for now):

```
git clone -b webrtc https://github.com/johni0702/mumble-web
cd mumble-web
npm install
npm run build
```

The npm version is prebuilt and ready to use whereas the git version allows you
to e.g. customize the theme before building it.

Either way you will end up with a `dist` folder that contains the static page.

#### Setup
At the time of writing this there do not seem to be any Mumble servers
which natively support Websockets+WebRTC. To use this client with any standard mumble
server, [mumble-web-proxy] must be set up (preferably on the same machine that the
Mumble server is running on).

Additionally you will need some web server to serve static files and terminate the secure websocket connection (mumble-web-proxy only supports insecure ones).

A sample configuration for nginx that allows access to mumble-web at 
`https://voice.example.com/` and connecting at `wss://voice.example.com/demo`
(similar to the demo server) looks like this:
```
server {
        listen 443 ssl;
        server_name voice.example.com;
        ssl_certificate /etc/letsencrypt/live/voice.example.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/voice.example.com/privkey.pem;

        location / {
                root /path/to/dist;
        }
        location /demo {
                proxy_pass http://proxybox:64737;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;
        }
}

map $http_upgrade $connection_upgrade {
        default upgrade;
        '' close;
}
```
where `proxybox` is the machine running mumble-web-proxy (may be `localhost`):
```
mumble-web-proxy --listen-ws 64737 --server mumbleserver:64738
```
If your mumble-web-proxy is running behind a NAT or firewall, take note of the respective section in its README.

### Configuration
The `app/config.js` file contains default values and descriptions for all configuration options.
You can overwrite those by editing the `config.local.js` file within your `dist` folder. Make sure to back up and restore the file whenever you update to a new version.

### Themes
The default theme of mumble-web tries to mimic the excellent [MetroMumble]Light theme.
mumble-web also includes a dark version, named MetroMumbleDark, which is heavily inspired by [MetroMumble]'s dark version.

To select a theme other than the default one, append a `theme=dark` query parameter (where `dark` is the name of the theme) when accessing the mumble-web page.
E.g. [this](https://voice.johni0702.de/?address=voice.johni0702.de&port=443/demo&theme=dark)is the live demo linked above but using the dark theme (`dark` is an alias for `MetroMumbleDark`).

Custom themes can be created by deriving them from the MetroMumbleLight/Dark themes just like the MetroMumbleDark theme is derived from the MetroMumbleLight theme.

### Matrix Widget
mumble-web has specific support for running as a widget in a [Matrix] room.

While just using the URL to a mumble-web instance in a Custom Widget should work for most cases, making full use of all supported features will require some additional trickery. Also note that audio may not be functioning properly on newer Chrome versions without these extra steps.

This assumes you are using the Riot Web or Desktop client. Other clients will probably require different steps.
1. Type `/devtools` into the message box of the room and press Enter
2. Click on `Send Custom Event`
3. Click on `Event` in the bottom right corner (it should change to `State Event`)
4. Enter `im.vector.modular.widgets` for `Event Type`
5. Enter `mumble` for `State Key` (this value may be arbitrary but must be unique per room)
6. For `Event Content` enter (make sure to replace the example values):
```
{
  "waitForIframeLoad": true,
  "name": "Mumble",
  "creatorUserId": "@your_user_id:your_home_server.example",
  "url": "https://voice.johni0702.de/?address=voice.johni0702.de&port=443/mumble&matrix=true&username=$matrix_display_name&theme=$theme&avatarurl=$matrix_avatar_url",
  "data": {},
  "type": "jitsi",
  "id": "mumble"
}
```
The `$var` parts of the `url` are intentional and will be replaced by Riot whenever a widget is loaded (i.e. they will be different for every user). The `username` query parameter sets the default username to the user's Matrix display name, the `theme` parameter automatically uses the dark theme if it's used in Riot, and the `avatarurl` will automatically download the user's avatar on Matrix and upload it as the avatar in Mumble.
Finally, the `matrix=true` query parameter replaces the whole `Connect to Server` dialog with a single `Join Conference` button, so make sure to remove it if you do not supply default values for all connection parameters as above.
The `type` needs to be `jitsi` to allow the widget to use audio and to stay open when switching to a different room (this will hopefully change once Riot is able to ask for permission from the user by itself).
The `id` should be the same as the `State Key` from step 5.
See [here](https://docs.google.com/document/d/1uPF7XWY_dXTKVKV7jZQ2KmsI19wn9-kFRgQ1tFQP7wQ/edit) for more information on the values of these fields.
7. Press `Send`

### License
ISC

[Mumble]: https://wiki.mumble.info/wiki/Main_Page
[mumble-web-proxy]: https://github.com/johni0702/mumble-web-proxy
[MetroMumble]: https://github.com/xPoke/MetroMumble
[Matrix]: https://matrix.org
