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

__Notice__ 

When you use this plugin for Android 10 (API level 29) or later, you can connect to the Internet only through your 
own (cordova) app. This is due to the specification of new Android API, [WifiNetworkSpecifier](https://developer.android.com/reference/android/net/wifi/WifiNetworkSpecifier).

If you want to purposely use the deprecated Android API, run the following.

```
cordova run android --device -- --gradleArg=-PcdvTargetSdkVersion=28 
```


## Usage

#### Connect to Wi-Fi access point

```javascript
const onDeviceReady = () => {
  window.wifiManager.connect(
    'SAMPLE_SSID',
    'SAMPLE_PASSPHRASE',
    () => {
      console.log('connect method was successfully called.');
    },
    (result) => {
      console.log('connect method failed to be called.');
      console.log(`code: ${result.code}, message: ${result.message}`);
    }
  );
};

document.addEventListener('deviceready', onDeviceReady, false);
```

#### Disconnect from Wi-Fi access point

```javascript
const onDeviceReady = () => {
  window.wifiManager.disconnect(
    'SAMPLE_SSID',
    () => {
      console.log('disconnect method was successfully called.');
    },
    (result) => {
      console.log('disconnect method failed to be called.');
      consoe.log(`code: ${result.code}, message: ${result.message}`);
    }
  );
};

document.addEventListener('deviceready', onDeviceReady, false);
```

## License

[MIT]: http://www.opensource.org/licenses/mit-license

`cordova-plugin-wifi-manager` is available under the [MIT license][MIT]. See the LICENSE file for details.
