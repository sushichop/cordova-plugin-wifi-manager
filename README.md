# cordova-plugin-wifi-manager

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/sushichop/cordova-plugin-wifi-manager/blob/main/LICENSE)
[![npm version](https://img.shields.io/npm/v/cordova-plugin-wifi-manager.svg?colorB=blue)](https://www.npmjs.com/package/cordova-plugin-wifi-manager)
![GitHub Actions](https://github.com/sushichop/cordova-plugin-wifi-manager/workflows/ci/badge.svg)
[![js-semistandard-style](https://img.shields.io/badge/code%20style-semistandard-brightgreen.svg)](https://github.com/Flet/semistandard)

Wi-Fi Manager Plugin for Apache Cordova

## Supported Platforms

- Android: 5.0 or later
- iOS: 10.0 or later

## Installation

```bash
cordova plugin add cordova-plugin-wifi-manager
```

__Notice__ If you use this plugin for Android 10 or later devices, follow the workaround as below for now.

```
cordova plugin add cordova-plugin-wifi-manager@0.2.1
cordova prepare
cordova run android --device -- --gradleArg=-PcdvTargetSdkVersion=28 
```

## Usage

#### Connect to Wi-Fi access point

```javascript
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady () {
  window.wifiManager.connect(
    'SAMPLE_SSID',
    'SAMPLE_PASSPHRASE',
    function () {
      console.log('connect method was successfully called.');
    },
    function (result) {
      console.log('disconnect method failed to be called. ' +
        'code: ' + result.code + ', message: ' + result.message);
    }
  );
}
```

#### Disconnect from Wi-Fi access point

```javascript
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady () {
  window.wifiManager.disconnect(
    'SAMPLE_SSID',
    function () {
      console.log('disconnect method was successfully called.');
    },
    function (result) {
      console.log('disconnect method failed to be called. ' +
        'code: ' + result.code + ', message: ' + result.message);
    }
  );
}
```

## License

[MIT]: http://www.opensource.org/licenses/mit-license

`cordova-plugin-wifi-manager` is available under the [MIT license][MIT]. See the LICENSE file for details.
