// Type definitions for cordova-plugin-wifi-manager 0.2.0
// Project: https://github.com/sushichop/cordova-plugin-wifi-manager
// Definitions by: Koichi Yokota <https://github.com/sushichop>

declare namespace WifiManagerPlugin {

  interface WifiManager {
    /**
     * Connects to Wi-Fi access point.
     * @param ssid SSID of Wi-Fi access point
     * @param passphrase passphrase of Wi-Fi access point
     * @param onSuccess success callback
     * @param onFailure failure callback
     */
    connect(
      ssid: string,
      passphrase: string,
      onSuccess: (ssid: string, passphrase: string) => void,
      onFailure: (code: number, message: string) => void,
    ): void;

    /**
     * Disconnects from Wi-Fi access point.
     * @param ssid SSID of Wi-Fi access point
     * @param onSuccess success callback
     * @param onFailure failure callback
     */
    disconnect(
      ssid: string,
      onSuccess: (ssid: string) => void,
      onFailure: (code: number, message: string) => void,
    ): void;
  }
}

interface Window {
  wifiManager: WifiManagerPlugin.WifiManager;
}

declare const wifiManager: WifiManagerPlugin.WifiManager;
