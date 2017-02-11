# resin-wifi-connect

[![Greenkeeper badge](https://badges.greenkeeper.io/reconbot/resin-wifi-connect.svg)](https://greenkeeper.io/)

A tool to allow wifi configuration to be set via a captive portal.

## Todo
- [ ] figure out why it doesn't work
- [ ] make a standalone npm package
- [ ] get rid of coffeescript
- [ ] make the ssid name include part of the uuid by default

## How to use this
This is a [resin.io](http://resin.io) application. Check out our [Getting Started](http://docs.resin.io/#/pages/installing/gettingStarted.md) guide if it's your first time using Resin.

This project is meant to be integrated as part of a larger application (that is, _your_ application). An example on how to use this on a Python project can be found [here](https://github.com/resin-io-projects/resin-wifi-connect-python-example).

If you need to add dependencies, add the corresponding statements in the [Dockerfile](./Dockerfile.template) template. You can add the commands that run your app in the [start](./start) script. This app only exits after a successful connection, so if you add your app after [line 3](./start#L3) you ensure that everything happens after wifi is correctly configured.

This is a node.js application, but your app can be any language/framework you want as long as you install it properly - if you need help, check out our [Dockerfile guide](http://docs.resin.io/#/pages/using/dockerfile.md). This project uses a Resin feature called "Dockerfile template": the base image is chosen depending on the architecture, specified by the `%%RESIN_ARCH%%` variable (see [line 1](./Dockerfile.template#L1) in the template).

## How it works
This app interacts with the Connman connection manager in Resin's base OS. It checks whether WiFi is connected, tries to join the favorite network, and if this fails, it opens an Access Point to which you can connect using a laptop or mobile phone.

The access point's name (SSID) is, by default, "ResinAP". You can change this by changing the "ssid" field in [wifi.json](./src/wifi.json). By default, the network is unprotected, but you can add a WPA2 passphrase by setting the "passphrase" field in the same file. Keep in mind that, once you set a passphrase, you can't go back to an unprotected network on an already provisioned device.
The server for wifi configuration uses port 8080 by default. This can also be configured in wifi.json, but it will be transparent to the user as all web traffic is redirected when in Access Point mode.

These three configurations can also be set with the environment variables `PORTAL_SSID`, `PORTAL_PASSPHRASE` and `PORTAL_PORT`, but keep in mind that the device has to be online to be able to download the new settings (you can use an ethernet cable or a WiFi network to which you've already connected).

When you connect to the access point, any web page you open will be redirected to our captive portal page, where you can select the SSID and passphrase of the WiFi network to connect to. After this, the app will disable the AP and try to connect. If it fails, it will enable the AP for you to try again. If it succeeds, the network will be remembered by Connman as a favorite.
