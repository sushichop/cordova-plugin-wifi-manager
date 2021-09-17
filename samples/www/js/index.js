'use strict';

const connect = () => {
  console.log('--- connect START ---');
  window.wifiManager.connect(
    'SAMPLE_SSID',
    'SAMPLE_PASSPHRASE',
    () => {
      document.getElementById('message').innerText = 'connect method was successfully called.';
    },
    (result) => {
      document.getElementById(
        'message'
      ).innerText = `connect method failed to be called. code: ${result.code}, message: ${result.message}`;
    }
  );
  console.log('--- connect END -----');
};

const disconnect = () => {
  console.log('--- disconnect START ---');
  window.wifiManager.disconnect(
    'SAMPLE_SSID',
    () => {
      document.getElementById('message').innerText = 'disconnect method was successfully called.';
    },
    (result) => {
      document.getElementById(
        'message'
      ).innerText = `disconnect method failed to be called. code: ${result.code}, message: ${result.message}`;
    }
  );
  console.log('--- disconnect END -----');
};

const httpGet = () => {
  console.log('--- httpGet START ---');
  fetch('https://httpbin.org/get')
    .then((response) => response.text())
    .then((text) => {
      document.getElementById('message').innerText = text;
    })
    .catch((error) => {
      document.getElementById('message').innerText = error;
    });
  console.log('--- httpGet END -----');
};

const browse = () => {
  console.log('--- browse START ---');
  cordova.InAppBrowser.open('https://apache.org', '_blank', 'location=yes');
  console.log('--- browse END -----');
};

const onDeviceReady = () => {
  console.log('--- onDeviceReady START ---');

  document.getElementById('deviceready').innerText = 'device is ready.';

  document.getElementById('connect').addEventListener('click', connect, false);
  document.getElementById('disconnect').addEventListener('click', disconnect, false);
  document.getElementById('http-get').addEventListener('click', httpGet, false);
  document.getElementById('browse').addEventListener('click', browse, false);

  console.log('--- onDeviceReady END -----');
};

document.addEventListener('deviceready', onDeviceReady, false);
