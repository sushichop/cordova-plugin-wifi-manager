// Type definitions for cordova-plugin-wifi-manager 0.4.0
// Project: https://github.com/sushichop/cordova-plugin-wifi-manager
// Definitions by: Koichi Yokota <https://github.com/sushichop>

declare namespace WifiManagerPlugin {
  /**
   * Defines WiFiManager.
   */
  interface WifiManager {
    /**
     * Connects to Wi-Fi access point.
     * @param ssid SSID of Wi-Fi access point.
     * @param passphrase Passphrase of Wi-Fi access point.
     * @param onSuccess Callback invoked when the connect method was successfully called.
     * @param onFailure Callback invoked when the disconnect method failed to be called.
     */
    connect(
      ssid: string,
      passphrase: string,
      onSuccess: SuccessCallback,
      onFailure: FailureCallback,
    ): void;

    /**
     * Disconnects from Wi-Fi access point.
     * @param ssid SSID of Wi-Fi access point.
     * @param onSuccess Callback invoked when the disconnect method was successfully called.
     * @param onFailure Callback invoked when the disconnect method failed to be called.
     */
    disconnect(
      ssid: string,
      onSuccess: SuccessCallback,
      onFailure: FailureCallback,
    ): void;
  }

  /**
   * Callback invoked when the method was successfully called.
   */
  type SuccessCallback = () => void;

  /**
   * Callback invoked when the method failed to be called.
   */
  type FailureCallback = (result: Result) => void;

  /**
   * Defines the result of callback.
   */
  interface Result {
    /**
     * Result code number.
     */
    code: number;

    /**
     * Result message.
     */
    message: string;
  }
}

interface Window {
  wifiManager: WifiManagerPlugin.WifiManager;
}

declare const wifiManager: WifiManagerPlugin.WifiManager;
