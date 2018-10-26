# Temp Tracker

This is work-in-progress nerves application to measure data from a Raspberry Pi. The project includes:
* A Phoenix web server backend to provide API endpoints to retrieve data from the raspberry pi d

This application follows the [Poncho Project](http://embedded-elixir.com/post/2017-05-19-poncho-projects/) structure.

## Setup

``` bash
cd temp_tracker_fw
export MIX_TARGET=rpi0
export NERVES_NETWORK_PSK=PASSKEY
export NERVES_NETWORK_SSID=SSID
mix deps.get
mix firmware
mix firmware.burn
```

Once the device is on the network,

```
mix firmware.push nerves.local
```

