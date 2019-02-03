# cordova-plugin-wifi-manager

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/sushichop/cordova-plugin-wifi-manager/blob/master/LICENSE)
[![npm version](https://img.shields.io/npm/v/cordova-plugin-wifi-manager.svg?colorB=blue)](https://www.npmjs.com/package/cordova-plugin-wifi-manager)
[![Build Status](https://img.shields.io/travis/sushichop/cordova-plugin-wifi-manager/master.svg)](https://travis-ci.org/sushichop/cordova-plugin-wifi-manager)

Wi-Fi Manager Plugin for Apache Cordova

## Supported Platforms

- Android: 4.4 or later
- iOS: 10.0 or later

## Installation

```bash
cordova plugin add cordova-plugin-wifi-manager
```

## Usage

#### Connect to Wi-Fi access point

```javascript
window.document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady () {
  window.wifiManager.connect(
    'TARGET_SSID',
    'TARGET_PASSPHRASE',
    function (success) { console.log(success); },
    function (failure) { console.log(failure); }
  );
}
```

#### Disconnect from Wi-Fi access point

```javascript
window.document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady () {
  window.wifiManager.disconnect(
    'TARGET_SSID',
    function (success) { console.log(success); },
    function (failure) { console.log(failure); }
  );
}
```

## License

[MIT]: http://www.opensource.org/licenses/mit-license

`cordova-plugin-wifi-manager` is available under the [MIT license][MIT]. See the LICENSE file for details.
