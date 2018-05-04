# cordova-plugin-wifi-manager

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
