package net.sushichop.cordova.wifimanager;

import android.annotation.TargetApi;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkRequest;
import android.net.wifi.WifiConfiguration;
import android.net.wifi.WifiManager;
import android.net.wifi.WifiNetworkSpecifier;
import android.os.Build;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


public class WiFiManagerPlugin extends CordovaPlugin {
    private static final int ERROR_CODE_OFFSET          = 1000;

    private static final int ADD_NETWORK_ERROR          =   1 + ERROR_CODE_OFFSET;
    private static final int ENABLE_NETWORK_ERROR       =   2 + ERROR_CODE_OFFSET;
    private static final int RECONNECT_ERROR            =   3 + ERROR_CODE_OFFSET;
    private static final int DISCONNECT_ERROR           =   4 + ERROR_CODE_OFFSET;
    private static final int DISABLE_NETWORK_ERROR      =   5 + ERROR_CODE_OFFSET;
    private static final int BIND_TO_NETWORK_ERROR      =  10 + ERROR_CODE_OFFSET;
    private static final int UNAVAILABLE_NETWORK_ERROR  =  11 + ERROR_CODE_OFFSET;
    private static final int UNKNOWN_ACTION_ERROR       = 100 + ERROR_CODE_OFFSET;

    private static final String ADD_NETWORK_ERROR_MESSAGE           = "addNetwork failed.";
    private static final String ENABLE_NETWORK_ERROR_MESSAGE        = "enableNetwork failed.";
    private static final String RECONNECT_ERROR_MESSAGE             = "reconnect failed.";
    private static final String DISCONNECT_ERROR_MESSAGE            = "disconnect failed.";
    private static final String DISABLE_NETWORK_ERROR_MESSAGE       = "disableNetwork failed.";
    private static final String BIND_TO_NETWORK_ERROR_MESSAGE       = "bindProcessToNetwork failed.";
    private static final String UNAVAILABLE_NETWORK_ERROR_MESSAGE   = "network is unavailable.";
    private static final String UNKNOWN_ACTION_ERROR_MESSAGE        = "unknownAction occurred.";

    private ConnectivityManager connectivityManager;
    private ConnectivityManager.NetworkCallback networkCallback;
    private WifiManager wifiManager;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);

        Context context = cordova.getActivity().getApplicationContext();
        if (isAndroidQOrLater()) {
            connectivityManager = (ConnectivityManager)context.getSystemService(Context.CONNECTIVITY_SERVICE);
        } else {
            wifiManager = (WifiManager)context.getSystemService(Context.WIFI_SERVICE);
        }
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        switch (action) {
            case "connect":
                connect(args, callbackContext);
                break;
            case "disconnect":
                disconnect(args, callbackContext);
                break;
            default:
                executeUnknownAction(callbackContext);
                break;
        }

        return true;
    }

    private static boolean isAndroidQOrLater() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q;
    }

    private void connect(JSONArray args, CallbackContext callbackContext) throws JSONException {
        String ssid = args.optString(0);
        String passphrase = args.optString(1);

        if (isAndroidQOrLater()) {
            connectAndroidQ(ssid, passphrase, callbackContext);
        } else {
            connectAndroid(ssid, passphrase, callbackContext);
        }
    }

    @TargetApi(Build.VERSION_CODES.Q)
    private void connectAndroidQ(final String ssid, final String passphrase, CallbackContext callbackContext) {
        WifiNetworkSpecifier.Builder wifiNetworkSpecifierBuilder = new WifiNetworkSpecifier.Builder()
                .setSsid(ssid)
                .setWpa2Passphrase(passphrase);

        NetworkRequest networkRequest = new NetworkRequest.Builder()
                .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
                .setNetworkSpecifier(wifiNetworkSpecifierBuilder.build())
                .build();

        if (networkCallback != null) {
            connectivityManager.unregisterNetworkCallback(networkCallback);
            networkCallback = null;
        }
        
        networkCallback = new ConnectivityManager.NetworkCallback() {
            @Override
            public void onAvailable(Network network) {
                super.onAvailable(network);
                JSONObject json = new JSONObject();
                if (connectivityManager.bindProcessToNetwork(network)) {
                    callbackContext.success();
                } else {
                    try {
                        json.put("code", BIND_TO_NETWORK_ERROR);
                        json.put("message", BIND_TO_NETWORK_ERROR_MESSAGE);
                    } catch(JSONException ignored) {
                    } finally {
                        callbackContext.error(json);
                    }
                }
            }

            @Override
            public void onUnavailable() {
                super.onUnavailable();
                JSONObject json = new JSONObject();
                try {
                    json.put("code", UNAVAILABLE_NETWORK_ERROR);
                    json.put("message", UNAVAILABLE_NETWORK_ERROR_MESSAGE);
                } catch(JSONException ignored) {
                } finally {
                    callbackContext.error(json);
                }
            }

            @Override
            public void onLost(Network network) {
                super.onLost(network);
            }

            @Override
            public void onCapabilitiesChanged(Network network, NetworkCapabilities networkCapabilities) {
                super.onCapabilitiesChanged(network, networkCapabilities);
            }
        };

        connectivityManager.requestNetwork(networkRequest, networkCallback);
    }

    private void connectAndroid(final String ssid, final String passphrase, CallbackContext callbackContext) throws JSONException {
        if (!wifiManager.isWifiEnabled()) {
            wifiManager.setWifiEnabled(true);
        }

        WifiConfiguration config = setWPAConfiguration(ssid, passphrase);
        int networkId = wifiManager.addNetwork(config);
        wifiManager.updateNetwork(config);

        JSONObject json = new JSONObject();

        if (networkId == -1) {
            json.put("code", ADD_NETWORK_ERROR);
            json.put("message", ADD_NETWORK_ERROR_MESSAGE);
            callbackContext.error(json);
            return;
        }

        if (!wifiManager.enableNetwork(networkId, true))  {
            json.put("code", ENABLE_NETWORK_ERROR);
            json.put("message", ENABLE_NETWORK_ERROR_MESSAGE);
            callbackContext.error(json);
            return;
        }

        if (!wifiManager.reconnect()) {
            json.put("code", RECONNECT_ERROR);
            json.put("message", RECONNECT_ERROR_MESSAGE);
            callbackContext.error(json);
            return;
        }

        callbackContext.success();
    }

    private void disconnect(JSONArray args, CallbackContext callbackContext) throws JSONException {
        String ssid = args.optString(0);

        if (isAndroidQOrLater()) {
            disconnectAndroidQ(callbackContext);
        } else {
            disconnectAndroid(ssid, callbackContext);
        }
    }

    @TargetApi(Build.VERSION_CODES.Q)
    private void disconnectAndroidQ(CallbackContext callbackContext) {
        if (networkCallback != null) {
            connectivityManager.unregisterNetworkCallback(networkCallback);
            networkCallback = null;
        }

        callbackContext.success();
    }

    private void disconnectAndroid(final String ssid, CallbackContext callbackContext) throws JSONException {
        WifiConfiguration config = setWPAConfiguration(ssid);
        int networkId = wifiManager.addNetwork(config);
        wifiManager.updateNetwork(config);

        JSONObject json = new JSONObject();

        if (networkId == -1) {
            json.put("code", ADD_NETWORK_ERROR);
            json.put("message", ADD_NETWORK_ERROR_MESSAGE);
            callbackContext.error(json);
            return;
        }

        if (!wifiManager.disconnect()) {
            json.put("code", DISCONNECT_ERROR);
            json.put("message", DISCONNECT_ERROR_MESSAGE);
            callbackContext.error(json);
            return;
        }

        if (!wifiManager.disableNetwork(networkId)) {
            json.put("code", DISABLE_NETWORK_ERROR);
            json.put("message", DISABLE_NETWORK_ERROR_MESSAGE);
            callbackContext.error(json);
            return;
        }

        callbackContext.success();
    }

    private void executeUnknownAction(CallbackContext callbackContext) throws JSONException {
        JSONObject json = new JSONObject();
        json.put("code", UNKNOWN_ACTION_ERROR);
        json.put("message", UNKNOWN_ACTION_ERROR_MESSAGE);
        callbackContext.error(json);
    }

    private WifiConfiguration setWPAConfiguration(String ssid, String passphrase) {
        WifiConfiguration config = new WifiConfiguration();
        config.SSID = "\"" + ssid + "\"";
        if (passphrase != null) {
            config.preSharedKey = "\"" + passphrase + "\"";
        }

        //config.status = WifiConfiguration.Status.ENABLED;

        config.allowedProtocols.set(WifiConfiguration.Protocol.WPA);
        config.allowedProtocols.set(WifiConfiguration.Protocol.RSN);
        config.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_PSK);
        config.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.TKIP);
        config.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.CCMP);
        config.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.TKIP);
        config.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.CCMP);

        return config;
    }

    private WifiConfiguration setWPAConfiguration(String ssid) {
        return setWPAConfiguration(ssid, null);
    }
}
