# Temp Tracker

This is a hobby nerves project built to collect temperature data using one or many Rasbperry Pi device(s). The application is set up to run on both RPi3 and RPi Zero W. Temperature measurements are taken using the [DS18B20 ](https://www.adafruit.com/product/381) temperature sensor using the one-wire protocol with GPIO.

The application follows the [poncho](https://embedded-elixir.com/post/2017-05-19-poncho-projects/) structure.
* **temp_tracker_fw** includes all nerves dependencies necessary and is used to build the firmware
* **temp_tracker** contains the business logic for measuring temperature data from the device
* **temp_tracker_ui** is a phoenix application and provides the web interface for reading measurements

## Setup

To deploy the application, ensure your SSH key is set up. Set the local wifi credentials in your environment using `NERVES_NETWORK_SSID` and `NERVES_NETWORK_PSK`.

First, prep the Phoenix project:

  ```bash
  # These steps only need to be done once.
  cd temp_tracker_ui
  mix deps.get
  npm install --prefix assets
  ```

Build your assets and prepare them for deployment to the firmware:

  ```bash
  # Still in temp_tracker_ui directory from the prior step.
  # These steps need to be repeated when you change JS or CSS files.
  npm install --prefix assets --production
  npm run deploy --prefix assets
  mix phx.digest
  ```

To build and push the firmware to an SD card:
``` bash
cd ../temp_tracker_fw
export MIX_TARGET=rpi0
export NERVES_NETWORK_PSK=PASSKEY
export NERVES_NETWORK_SSID=SSID
mix deps.get
mix firmware
mix firmware.burn
```

Once the device is on the network,

```
mix upload nerves.local
```

To access the device's iex console:
```
ssh nerves.local
```
