'use strict';

var PLUGIN_NAME = 'WiFiManager';
var argscheck = require('cordova/argscheck');
var exec = require('cordova/exec');

/**
 * Connects to Wi-Fi access point.
 *
 * @param ssid {String} SSID of Wi-Fi access point
 * @param passphrase {String} passphrase of Wi-Fi access point
 * @param successCb {Function} success callback
 * @param failureCb {Function} failure callback
 */
function connect (ssid, passphrase, successCb, failureCb) {
  argscheck.checkArgs('ssFF', PLUGIN_NAME + '.connect', arguments);
  exec(successCb, failureCb, PLUGIN_NAME, 'connect', [ssid, passphrase]);
}

/**
 * Disconnects from Wi-Fi access point.
 *
 * @param ssid {String} SSID of Wi-Fi access point
 * @param successCb {Function} success callback
 * @param failureCb {Function} failure callback
 */
function disconnect (ssid, successCb, failureCb) {
  argscheck.checkArgs('sFF', PLUGIN_NAME + '.disconnect', arguments);
  exec(successCb, failureCb, PLUGIN_NAME, 'disconnect', [ssid]);
}

module.exports = {
  connect: connect,
  disconnect: disconnect
};
